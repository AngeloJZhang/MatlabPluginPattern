% ==============================================================================
%  The Application class takes in the configuration and generates the
%  classes from the configuration to run the app
% ==============================================================================
classdef Application < handle
    methods(Access = public)
        function obj = Application(path_to_config)
            
            [imports, functions] = core.ConfigLoader.load(path_to_config);
            importer = core.Importer(imports);

        end % function

    end % methods

end % classdef