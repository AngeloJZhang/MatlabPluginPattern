classdef testOpaqueOne < common.OpaqueBox
    % ==========================================================================
    %  This is the testOpaqueBox
    % ==========================================================================
    methods
        function obj = testOpaqueOne()
            % ==================================================================
            %  Constructor
            % ==================================================================

            obj.input_vars = [];

            obj.output_vars = [ ...
                "testfieldA", "double";
                "testfieldB", "string";
                ];

        end % function

        function work_struct = apply(obj, work_struct)
            % ==================================================================
            %  Base Apply function
            % ==================================================================
            arguments

                % Base Object
                obj (1, 1) common.OpaqueBox

                % Struct that contains workspace
                work_struct (1, 1) struct

            end % arguments

            work_struct.testfieldA = 1;
            work_struct.testfieldB = "test";

        end % function

        function debug(obj)
            pass
        end % function

    end % methods

end % classdef