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

    % Constant Variables
    properties (Constant)

        % The following variable contains required fields for the
        % configuration that is loaded.
        REQUIRED_FIELDS = ["imports", "functions"]

    end % properties

    methods (Static)
        function [imports, functions] = load(path_to_config)
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

            % JSONs read '\' as an escape character and requires '\\' instead.  
            config_data = strrep(config_data, "\", "\\");

            % Combine everything into a single string and decode
            config = jsondecode(config_data.join(newline));

            % Verify that the two fieldnames exist
            fields = fieldnames(config);

            if ~all(contains(fields, core.ConfigLoader.REQUIRED_FIELDS))
                error("Config file does not contain required fields : %s", path_to_config);
            end % if

            % The following data is parsed in their individual classes
            imports = config.imports;
            functions = config.functions;
            
        end % function

    end % methods

end % classdef