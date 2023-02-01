% ==============================================================================
%  The OpaqueBox is an object that acts as an interface to every action
%  block used in the system. This predefines methods and properties that are
%  used to ensure all boxes can be used by common.UtilEngine.
% ==============================================================================

classdef OpaqueBox < handle
    % ==========================================================================
    %  The OpaqueBox is implemented as an interface and thus has majority
    %  virtual functions. This is not meant te follow any software
    %  standards defined in C++, Java, or Python OOP. This entire class is
    %  not listed as a virtual class so on the off chance a static
    %  function is required it can be added.
    % ==========================================================================

    %% Required Properties
    properties (GetAccess = public, SetAccess = protected, AbortSet)

        % ======================================================================
        %  Highly Complicated systems will inevitably be linked in some
        %  fashion. The input variables are used to validate inputs.
        %  The format of the input variables are <"Name", "ClassType">.
        % ======================================================================
        input_vars (2, :) string

        % ======================================================================
        %  Highly Complicated systems will inevitably be linked in some
        %  fashion. The output variables are used to validate outputs.
        %  The format of the output variables are strings of
        %  <"VariableName", "ClassType">.
        %  i.e, <"MyNumberField", "double">
        % ======================================================================
        output_vars (2, :) string

    end % properties

    %% Virtual Methods
    methods (Abstract)

        % ======================================================================
        %  Apply is the function that actually applies what is intended to
        %  the instructions. Run wraps this function to ensure everything
        %  is validated before we call this function.
        % ======================================================================
        work_struct = apply(obj, work_struct)

        % ======================================================================
        %  Debug is used for plotting, printing verbose, etc.
        % ======================================================================
        debug(obj)

    end % methods

    %% Public Methods
    methods (Access = public)
        function work_struct = run(obj, work_struct)
            % ==================================================================
            % Run is the function that runs the system.
            % ==================================================================
            obj.validate(work_struct);
            work_struct = obj.apply(work_struct);
        end

    end

    %% Inherited Methods
    methods (Access = protected)
        function validate(obj, work_struct)
            % ==================================================================
            % Validate ensures that box contains necessary components to run
            % ==================================================================

            diff_fields = setdiff(obj.input_vars(1, :), fieldnames(work_struct));

            if ~isempty(diff_fields)
                error("Missing Fields in %s: %s", dbstack(1).name, diff_fields)
            end % if

            for input_var = obj.input_vars
                if ~isa(work_struct.(input_var(1)), input_var(2))
                    error("Field %s is not a %s", input_var(1), input_var(2));

                end % if

            end % for

        end % function

    end % methods

end % classdef