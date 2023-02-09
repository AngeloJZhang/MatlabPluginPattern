% ==============================================================================
%  The ImportLib class manages imports to the data and handles the pathing
%  to said directories using symlinks to the lib folder. This allows for
%  a more proper pathing in matlab without the need to add every folder in
%  a share coding space. In addition, it allows for import commands such
%  that paths do not persist between function calls. This class is a
%  singleton class.
% ==============================================================================
classdef ImportLib < handle

    % ==========================================================================
    %  Within the Application, the import allows for a very pythonic way of
    %  linking directories. By using the ImportLib, in conjuction with the
    %  pathguard, we create something simpler to the import command such
    %  that, multiple functions with the same name should never be an
    %  issue as they are seperate by both namespace and pathing.
    % ==========================================================================

    %% Constant Variables
    properties(Constant)

        % This field points to the directory of the imports
        IMPORT_SYM_DIR = "+lib"

    end % properties

    %% Private Variables
    properties(GetAccess = public, SetAccess = private)

        % This container holds the references between the path to the script
        % and the name of the library
        ref_map containers.Map;

    end % properties

    methods (Access = public)
        function obj = ImportLib(ref_struct, plugins_list)
            % ==================================================================
            %  Constructor
            % ==================================================================
            arguments

                % The reference_struct is a <key, value> pair containing the
                % reference name of the library and the path to the
                % library. This is received from the ConfigLoader.
                ref_struct (1, 1) struct = struct();

                % The plugins list is a list of plugin names that are to be
                % incorporated into the system. These directories should
                % all exist within the +plugin folder.
                plugins_list (1, :) string = [];


            end % arguments

            if isequal(ref_struct, struct())
                error("Reference Structure much contain a value.");
            end

            % Validate that the <key, value> pairs are strings.
            % Shifted to row to iterate, matlab does not allow iteration
            % through columns of data.
            for field = string(fieldnames(ref_struct)).'
                if ~isstring(ref_struct.(field)) && ~ischar(ref_struct.(field))
                    error("Import key value pair not a string for key: %s", field);

                end % if

            end % for

            % Create the import paths for plugins
            for plugin = plugins_list

                % The path to the plugins library is taken from the PluginLoader.
                plugin_path = fullfile(core.PluginLoader.PLUGIN_DIR, plugin);

                % Verify that the plugin exists.
                if ~exist(plugin_path, "dir")
                    error("Plugin does not exist in plugins directory: %s", plugin);
                end % if

            end % for

            % Set the values into the map
            plugin_keys = plugins_list;
            import_keys = string(fieldnames(ref_struct));
            plugin_paths = fullfile(core.PluginLoader.PLUGIN_DIR, plugins_list);
            import_paths = string(struct2cell(ref_struct));

            obj.ref_map = containers.Map([plugin_keys import_keys], [plugin_paths import_paths]);

            % Create a Symlink for all the Imports
            for key = import_keys
                link_source = obj.ref_map(key);
                link_dest = fullfile(core.ImportLib.IMPORT_SYM_DIR, key);
                core.ImportLib.symlink(link_dest, link_source);

            end % for

            % Create callback for delete function call since occasionally
            % the destructor for matlab does not choose to work. This is a
            % known issue, when it comes to class instances.
            addlistener(obj, 'ObjectBeingDestroyed', @(obj, ~) cleanup(obj));

        end % function

        function import_name = subsref(obj, ref_struct)
            % ==================================================================
            %  This function sets the paths of the library that
            %  that user wants with the ImportLib object. It assigns a guard
            %  within the scope of the function so that it automatically
            %  clears when the function ends.
            %
            %  Unfortunately, dynamic imports are not possible due to the
            %  following bug so the import_name is passed out to serve as
            %  an import point. When, this bug has been fixed, a dynamic
            %  import point should be placed.
            %
            %  While this class can use the mix in for dot indexing it does
            %  not because there is no assignment of values.
            %
            %  https://www.mathworks.com/matlabcentral/answers/1877397-dynamic-import-with-evalin-not-possible
            %
            %  Usage : import(<ImportLib Obj>.<Library Name>)
            %
            %  Example : import(lib.testclass) -> this sets the path and
            %                                     imports testclass and
            %                                     gets cleared at funct end
            % ==================================================================
            arguments
                
                % The Import Object itself
                obj (1, 1) core.ImportLib

                % The Reference Key that the user imports
                ref_struct (1, 1) struct

            end % arguments

            ref_key = string(ref_struct.subs);

            % Perform Validation on the Subscript
            if length(ref_key) > 1
                error("This class does not support multiple subscripts.")
            end

            % Validate the key
            if ~any(contains(obj.ref_map.keys, ref_key))
                error("ref_key does not exist in object map: %s", ref_key);
            end

            import_path = obj.ref_map(ref_key);
            pathguard_obj = core.PathGuard(import_path);

            % This evaluates in the caller the PathGuard and the Import
            % step so that the user can immediately being using their lib
            assignin("caller", ref_key + "_path_guard", pathguard_obj);
            import_name = ref_key + ".*";
        end % function

    end % methods

    methods (Sealed, Access = private)
        % The following function is seal because it does not act like a
        % normal delete function. It deletes when called by the listener.
        % Nothing else should call this function.
        function cleanup(obj)
            % ==================================================================
            %  Destructor
            % ==================================================================

            % Clear out the lib directory
            for link = dir(core.ImportLib.IMPORT_SYM_DIR).'

                % If dir are pointers to parent directories ignore them
                if contains(link.name, ".")
                    continue;

                end % if

                % Delete the link files
                delete(fullfile(link.folder, link.name));

            end % for

        end % function
    end % methods

    methods (Static)
        function status = symlink(link_dest, link_source)
            % ==================================================================
            %  This function create a symlink by calling system commands.
            %  The symlinks generated by the ImportLib are mapped to the lib
            %  directory and are deleted upon the removal of the ImportLib.
            % ==================================================================
            arguments

                % Location of where the link will be created.
                link_dest (1, 1) string

                % The source of the link file or directory.
                link_source(1, 1) string
            end

            % Ensure the paths are valid.
            if exist(link_source, "dir")
                options = "/d /j";

            elseif exist(link_source, "file")
                options = "/d";

            else
                error("File or Dir %s does not exist.", link_source);

            end % if


            % Check for the system OS.
            if ismac
                % TODO : I have never used mac

            elseif isunix
                % TODO : Test on linux

            elseif ispc
                link_cmd = sprintf("mklink %s %s %s", options, link_dest, link_source);

            else
                error('Platform not supported')

            end % if

            % Run the command.
            [status, stdout] = system(link_cmd);

            % 1 means exited out ungracefully.
            if status == 1
                error("Command Failed : %s", stdout);

            end % if

        end % function

    end % methods

end % classdef