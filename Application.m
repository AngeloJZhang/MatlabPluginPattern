% ==============================================================================
%  The Application class takes in the configuration and generates the
%  classes from the configuration to run the app
% ==============================================================================
classdef Application < handle

    properties (SetAccess = private, AbortSet)

        % This structure holds the configuration
        config
    end

    methods (Access = public)
        function obj = Application(path_to_config)
            
            % Import the core directory
            import core.*
            
            [imports, functions, plugins] = ConfigLoader.load(path_to_config);

            obj.config.lib = ImportLib(imports);
            obj.config.util_list = FunctionLoader(functions);
            PluginLoader(plugins, obj.config.util_list)
            
            

        end % function

    end % methods

end % classdef