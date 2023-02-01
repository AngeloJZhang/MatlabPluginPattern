classdef testOpaqueTwo < common.OpaqueBox
    % ==========================================================================
    %  This is the testOpaqueBox
    % ==========================================================================
    methods
        function obj = testOpaqueTwo()
            % ==================================================================
            %  Constructor
            % ==================================================================

            obj.input_vars = [
                "testfieldA", "double";
                ];

            obj.output_vars = [
                "testfieldC", "double";
                ];

        end % function

        function work_struct = apply(obj, work_struct)
            % ==================================================================
            %  Base apply function
            % ==================================================================
            arguments

                % Base Object
                obj (1, 1) common.OpaqueBox

                % Struct that contains workspace
                work_struct (1, 1) struct

            end % arguments

            work_struct.testfieldC = work_struct.testfieldA +  1;

        end % function

        function debug(obj)
            pass
        end % function

    end % methods

end % classdef