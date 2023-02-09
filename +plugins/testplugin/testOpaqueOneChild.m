classdef testOpaqueOneChild < logic.testOpaqueOne
    methods(Access = protected)

        function work_struct = functA(obj, work_struct)
            % This overloads the superclass function
            work_struct.testfieldA = 2;

        end % function

        function work_struct = functB(obj, work_struct)
            % This calls the superclass function
            work_struct = functB@logic.testOpaqueOne(obj, work_struct);

            % Show that you can append to the parent function;
            work_struct.testfieldB = work_struct.testfieldB + "_inherited";

        end % function

    end % methods

end % classdef