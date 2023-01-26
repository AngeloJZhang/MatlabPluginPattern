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

        function obj = UtilBox(action_items, input)
            % ==================================================================
            %  Constructor
            % ==================================================================
            arguments

                % Actions_items are the list of input actions the system
                % will perform, these come in the form of common.OpaqueBox
                action_items (1, :) common.OpaqueBox;

                % Input is the input variable that maybe required by the
                % action_items to perform their tasks
                input (1, :) struct = [];

            end % arguments

            obj@common.UtilEngine(action_items, input);

        end % function

    end % methods

end % classdef