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
        % ======================================================================
        action_items (1, :) common.OpaqueBox = [];

        % ======================================================================
        %  Input is the input variables that maybe requried by the actions
        % ======================================================================
        % TODO : Look into changing this into a class
        input (1, 1) struct = [];

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
                opts.action_items (1, :) common.OpaqueBox;

                % Input is the input variable that maybe required by the
                % action_items to perform their tasks
                opts.input (1, :) struct = [];

            end % arguments

            obj.action_items = opts.action_items;
            obj.input = opts.input;

        end % function
        
        function output = run(obj)
            % ==================================================================
            %  This is the primary function that is used to run the actions
            % ==================================================================
            arguments

                % Base UtilEngine
                obj (1, 1) UtilEngine;

            end % arguments

            input = obj.input;

            % TODO : Figure out how to parfor correctly it maybe that a
            % different class will be required all together for threadable
            % tasking. This needs investigation.

            for action = obj.action_items

                % TODO : place in try catch loop and catch the exception
                action.validate(input);
                output = action.run(input);

                % This marks the end of an action and the start of the next
                input = output;

            end % for

        end % function

        function validate(obj, input)
            % ==================================================================
            %  This is the primary function that is used to validate
            %  inputs. This just becomes the validation function of the
            %  first item in the action list.
            % ==================================================================
            % TODO : Ensure there are no bugs due to this validation
            % method. There maybe troubles when attempting to thread this.
            
            % TODO: It maybe worth doing some form of bubbling up of
            % validation for non-dependant variables maybe by way of
            % informing outputs.

            % TODO: Try catch Raise
            obj.action_items(1).validate(input);
        end

        function debug(obj)
            % TODO : Unsure of what part debug should play yet, it may need to 
            % stay as an abstract function for now
            pass
        end

    end % methods

end % classdef