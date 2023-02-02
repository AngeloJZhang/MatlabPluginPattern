% ==============================================================================
%  The UtilBox is a combination of a common.OpaqueBox and common.UtilEngine.
%  This enables a tree like recusion of actions but also, allows for the
%  UtilBoxs to run standalone. In addition, it allows for functions to be
%  replaced, updated, or extended through the use of OOP.
% ==============================================================================

classdef UtilBox < common.UtilEngine & common.OpaqueBox
    % ==========================================================================
    %  The UtilBox maps the correct functions from the UtilEngine into the
    %  OpaqueBox functionality so that it allows for the an OpaqueBox that
    %  runs other OpaqueBoxes. Arguably this can be done better with
    %  composition, but I love the thought of being able to merge an Engine
    %  into a Box to create a monstrosity.
    % ==========================================================================

    %% Public methods
    methods (Access = public)

        function obj = UtilBox(opts)
            % ==================================================================
            %  Constructor
            % ==================================================================
            arguments

                % Actions_items are the list of input actions the system
                % will perform, these come in the form of common.OpaqueBox
                opts.action_items (1, :) cell;

            end % arguments

            obj@common.UtilEngine(action_items=opts.action_items);
            obj.generate_reqs();

        end % function

        function output = apply(obj, work_struct)
            % ==================================================================
            %  This function designates the UtilEngine function as the
            %  proper apply function for a Utilbox.
            % ==================================================================
            output = apply@common.UtilEngine(obj, work_struct);

        end % function

        function debug(obj)
            % TODO : Figure out what this does
            pass
        end

    end % methods

    methods (Access = protected)
        function [input_vars, output_vars] = generate_reqs(obj)
            % ==================================================================
            %  The following loops through the internal variable inputs and
            %  output variables to create the vars so ensure at a high
            %  level that action list is valid.
            % ==================================================================

            input_vars = [];
            output_vars = [];

            for actions = obj.action_items
                input_vars = vertcat(input_vars, actions{:}.input_vars);
                output_vars = vertcat(output_vars, actions{:}.output_vars);
            end

            obj.input_vars = setdiff(input_vars, output_vars, "rows");
            obj.output_vars = output_vars;

        end % function

    end % methods

end % classdef