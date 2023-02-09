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

        function num_actions = length(obj)
            % ==================================================================
            %  This function finds the total action length of the
            %  action list by going through the action items list.
            % ==================================================================
            arguments

                % Base Object
                obj (1, 1) common.UtilEngine

            end % arguments

            num_actions = 0;
            for action = obj.action_items

                % If the action is an Engine then have it perform this
                % length function as well.
                if isa(action{:}, "common.UtilEngine")
                    num_actions = num_actions + action{:}.length();
                    continue;

                end % if

                % If the action is not an Engine then add one and go to the
                % next action in the list.
                num_actions = num_actions + 1;

            end % for

        end % function

        function box_replace(obj, box_handle)
            % ==================================================================
            %  This function find the action that is the direct parent
            %  class of the box handle (not grand-parent etc) and replaces
            %  it with the child.
            % ==================================================================
            
            
            parents = superclasses(box_handle);

            % There are no parents for this handle therefore, do nothing.
            if isempty(parents)
                return
            end % if

            % TODO : Change this to handle multiple inheritance.
            parent_name = parents{1};

            % TODO : It maybe worth keeping a list of parents on creation
            % of this object for quicker sorting and search.
            % If the parent is just a base handle then don't bother with
            % loading.
            if isa(parent_name, "handle")
                return
            end % if

            for action_iter = length(obj.action_items)

                action = obj.action_items(action_iter);

                % If the class is a UtilEngine then call this same
                % function to replace blocks.
                if isa(action{:}, "common.UtilEngine")

                    action{:}.box_replace(box_handle);

                end % if

                % Check the action handle and see if it can be removed. The
                % following is purposefully done instead of using "isa" so
                % that only the first parent is checked.
                if strcmp(class(action{:}), parent_name)

                    % Set the action into the action_items list;
                    obj.action_items{action_iter} = box_handle;

                end % if
                
            end % for

        end % function

    end % methods

end % classdef