classdef testOpaqueOneChild < testOpaqueOne
    methods(Access = protected)

        function work_struct = functA(work_struct)
            % This does something with testfieldA
            functA@super
            work_struct.testfieldA = 2;
        end % function
    end % methods
end % classdef