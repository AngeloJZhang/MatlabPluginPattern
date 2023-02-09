% ==============================================================================
%  The PluginLoader loads in plugin packages and corrects the pathing and
%  imports the configuration and libraries into the Application
% ==============================================================================
classdef PluginLoader < handle
    % ==========================================================================
    %  This class takes the plugin directory and looks through it to load
    %  the packages one at a time. The plugin loading order is determined
    %  by the configuration file.
    % ==========================================================================

    %% Constants
    properties(Constant)

        % This is the plugin directory
        PLUGIN_DIR = "+plugins";

    end % properties

    %% Static Methods
    methods(Static)
        function functions = load(plugins, functions)
            % ==================================================================
            %  This function loads in Plugins that are located within the
            %  plugin package directory and imports them into the App.
            % ==================================================================
            arguments

                % This is a string of plugin names that are to be included
                % in the Application. This string specfies the order loaded.
                plugins (1, :) string

                % This is the Action list to be run by the Application
                functions (1, :) cell

            end % arguments

            % This should contain a list of all plugins
            dir_obj = dir(core.PluginLoader.PLUGIN_DIR);
            dir_names = string({dir_obj.name});

            % Loop through plugins
            for plugin = string(plugins)

                % If plugins exist then load it
                if any(contains(dir_names, plugin))
                    valid_functs = core.PluginLoader.validate_plugin(plugin);
                    core.PluginLoader.load_plugin(valid_functs, functions);
                else
                    warning("Cannot find plugin: %s in plugin dir.", plugin);

                end % if

            end % for

        end % function

        function load_plugin(new_functs, existing_functs)
            % ==================================================================
            %  This function loads the validated plugin functions into the
            %  existing functions so that they can be run together.
            % ==================================================================

            for existing_funt = existing_functs
                for new_funct = new_functs

                    % This calls into the box_replace function to replace
                    % the boxes. See common.UtilBox.
                    existing_funt{:}.box_replace(new_funct{:});

                end % end

            end % end

        end % function

        function valid_functs = validate_plugin(plugin)
            % ==================================================================
            %  This function validates that plugin is properly configured
            % ==================================================================
            disp("[INFO] TODO: Document Example Plugin");

            valid_functs = {};
            dir_obj = dir(fullfile(core.PluginLoader.PLUGIN_DIR, plugin));

            for file_obj = dir_obj.'

                % Ignore the references for the parent directory
                if file_obj.isdir && contains(file_obj.name, ".")
                    continue;

                end % if

                filename = file_obj.name;
                if contains(filename, "@")
                    filename = strrep(filename, "@", "");

                end % if

                if contains(filename, ".m")
                    filename = strrep(filename, ".m", "");

                end % if

                if exist(filename, 'class')
                    fprintf("[INFO] found %s. Found Function.\n", filename);
                    valid_functs{end + 1} = eval(filename);
                    continue;
                end % if

            end % for

        end % function

    end % methods

end % classdef
