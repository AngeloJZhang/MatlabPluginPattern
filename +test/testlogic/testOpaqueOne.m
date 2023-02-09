classdef testOpaqueOne < common.OpaqueBox
    % ==========================================================================
    %  This is the testOpaqueBox
    % ==========================================================================
    
    %% Public Functions
    methods (Access = public)
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

            work_struct = obj.functA(work_struct);
            work_struct = obj.functB(work_struct);

        end % function

        function debug(obj)
            pass
        end % function

    end % methods

    %% Protected Functions
    methods(Access = protected)

        function work_struct = functA(obj, work_struct)
            % This does something with testfieldA
            work_struct.testfieldA = 1;
        end % function

        function work_struct = functB(obj, work_struct)
            % This does something with testfieldB
            work_struct.testfieldB = "test";
        end % function

    end

end % classdef