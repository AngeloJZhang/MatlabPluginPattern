% ==============================================================================
%  The Function loader acts as a factory and generates the objects in order
%  to run the Application.
% ==============================================================================
classdef FunctionLoader < handle
    % ==========================================================================
    %  The FunctionLoader creates the OpaqueBoxes and checks to verify that the
    %  correct namespaces are generated. This allows for items to be extensible
    %  and scalable.
    % ==========================================================================

    % Static Functions
    methods(Static)
        function output = load(funct_config)
            % ==================================================================
            %  This function performs the loading of the config data
            % ==================================================================
            arguments

                % This variable contains the information for the function lists 
                funct_config (1, 1) struct
            end
            
            % The function Loader always takes from the logic section first
            % before looking at other sections
            import logic.*;

            % Import the UtilBox
            import common.UtilBox;

            % This function outputs a UtilBox list
            fields = string(fieldnames(funct_config));
            output = cell(1, length(fields));

            % For each EngineBox with in the configuration, check to see that the
            % EngineBox exists with the scope. Then create the handles of
            % the actions requried to run it according to the
            % configuration.
            for field_iter = 1 : length(fields)
                field = fields(field_iter);
                action_names = funct_config.(field);
                action_items = {};

                for action = string(action_names).'

                    % There is a priority in the check, first the logic
                    % folder is checked to see if the action is
                    % pre-existing, then the plugin are checked.
                    if exist(action, 'class')
                        action_items{end + 1} = eval(action);
                        continue;
                    end % if

                    % If the function cannot be found it's likely in the
                    % plugins, set this aside for now.
                    error("TODO: Handle plugin functions");
                    
                end % for

                % Create the UtilBox
                output{field_iter} = UtilBox(action_items=action_items);

            end % for

        end % function

    end % methods

end % classdef
