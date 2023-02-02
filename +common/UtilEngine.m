% ==============================================================================
%  The UtilEngine is the class that drives the extensible codeblock that is
%  inherited by all classes. This engine allows for a recusive tree like
%  structure of running algorithms.
% ==============================================================================

classdef UtilEngine < handle
    % ==========================================================================
    %  The UtilEngine works by accepting a list of common.OpaqueBox objects
    %  and run the accepted list in order. It then performs a check on each
    %  stage to act as verification that OpaqueBox performed the necessary
    %  computations. Misc variables are stored in the {{{pre-defined
    %  messaging}}}
    %  class structure.
    % ==========================================================================

    % TODO : Define atomic actions for parallelized running of the engine

    %% Required Properties
    properties (SetAccess = public, GetAccess = public, AbortSet)

        % ======================================================================
        %  Action_items is the list of actions that the system will perform
        %  Realistically, this should be a list of class handles however,
        %  matlab has a very strange way of initializing object arrays.
        % ======================================================================
        action_items (1, :) cell = [];

    end % properties

    %% Public methods
    methods (Access = public)

        function obj = UtilEngine(opts)
            % ==================================================================
            %  Constructor
            % ==================================================================
            arguments

                % Actions_items are the list of input actions the system
                % will perform, these come in the form of common.OpaqueBox
                opts.action_items (1, :) cell;

            end % arguments

            % Validate action_items
            for item = opts.action_items
                if ~isa(item{:}, "common.OpaqueBox")
                    error("Action is not a child of OpaqueBox: %s\n", item{:});

                end % if

            end % for

            obj.action_items = opts.action_items;

        end % function
        
        function output = apply(obj, work_struct)
            % ==================================================================
            %  This is the primary function that is used to apply the actions
            % ==================================================================
            arguments

                % Base UtilEngine
                obj (1, 1) common.UtilEngine;

                % Input data
                work_struct (1, 1) struct;

            end % arguments

            input = work_struct;

            % TODO : Figure out how to parfor correctly it maybe that a
            % different class will be required all together for threadable
            % tasking. This needs investigation.

            for action = obj.action_items

                % TODO : place in try catch loop and catch the exception
                output = action{:}.run(input);

                % This marks the end of an action and the start of the next
                input = output;

            end % for

        end % function

    end % methods

end % classdef