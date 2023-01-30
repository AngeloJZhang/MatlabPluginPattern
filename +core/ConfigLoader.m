% ==============================================================================
%  The ConfigLoader loads in the configuration values and ensure that the
%  libraries and core components exist. This ConfigLoader does not act as the
%  the factory for the classes.
% ==============================================================================
classdef ConfigLoader < handle
    % ==========================================================================
    %  The ConfigLoader Parses in the JSON values within the config
    %  and passes the data to Application so that the actions can be
    %  generated in the order listed. For this particular application,
    %  before the JSONs are load in there is a file reader that parses out
    %  the symbol '#' so that it can be used as line comments.
    % ==========================================================================
    methods (Static)
        function config = load(path_to_config)
            % ==================================================================
            %  This function is static and loads in the config. It is a class
            %  because while there is likely no need for multiple configuraitons.
            %  In the case multiple loaders are needed it allows for easy
            %  transition for the future coder.
            % ==================================================================
            arguments

                % Path to the configuration
                path_to_config (1, 1) string {mustBeFile}

            end % arguments

            txt_data = readlines(path_to_config);
            
            % The following is just a simple negative look ahead with regexp
            % Potentially a multi-line comment removal can be done,
            % however, that gets very complicated very quickly.
            config_data = regexp(txt_data, "^(?!(\s*)\#).*", "match", "noemptymatch");

            % Reformat the config data from cell array to string array
            config_data = [config_data{:}];

            % Combine everything into a single string and decode
            config = jsondecode(config_data.join(newline));

        end % function

    end % methods

end % classdef