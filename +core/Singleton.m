% ==============================================================================
%  This class is a loosely defined Singleton class that use inherited by
%  other classes in the Application
% ==============================================================================
classdef Singleton < handle

    properties (GetAccess = public, SetAccess = private)
        % This serves as the name of the Singleton Instance in the
        % off chance multiple instances such as loggers are needed.
        name (1, 1) string

    end % properties

    properties (Hidden)

        % This variable is a function handle and solely lives so that the
        % deconstructor for matlab actually does it's job when clear is
        % called on the variable.
        singleton_cleanup

    end % properties

    methods(Access = public)
        function obj = Singleton(name, varargin)
            % ==================================================================
            %  This function looks for an existing instances of the
            %  Singleton class. If it find an existing instance, then it is
            %  returned instead.
            % ==================================================================
            arguments

                % This serves as the name of the Singleton Instance in the
                % off chance multiple instances such as loggers are needed.
                name (1, 1) string

            end % arguements

            arguments(Repeating)

                % This is a placeholder variable for any extra variables
                % that the child class may need for the Constructor.
                varargin

            end % arguements

            obj.name = name;

            % There maybe a better way of doing this such as tying this
            % variable to a persistent variable however, I am unsure of how
            % matlab interacts with persistent variables in classes as the
            % documentation is lacking.
            global UNIQUE_INSTANCE

            if isempty(UNIQUE_INSTANCE)
                % If variable does not exist at all create it.
                obj = obj.Instance(varargin{:});
                UNIQUE_INSTANCE.(name) = obj;
                obj.singleton_cleanup = onCleanup(@()delete(obj));
                return
            end

            % If variable does exist try to find an instance.
            name_idx = contains(fieldnames(UNIQUE_INSTANCE), name);

            if any(name_idx)
                obj = UNIQUE_INSTANCE.(name);
                return

            end % if

            % If no variables are found that match it then create one.
            obj = obj.Instance(varargin{:});
            UNIQUE_INSTANCE.(name) = obj;
            obj.singleton_cleanup = onCleanup(@()delete(obj));

        end % function

        function delete(obj)
            % ==================================================================
            %  This function checks how many handles to the Singleton
            %  Instance still exists. If there are no more left then it
            %  deletes the object.
            % ==================================================================

            % See Constructor for comment.
            global UNIQUE_INSTANCE

            UNIQUE_INSTANCE.(obj.name) = [];
            UNIQUE_INSTANCE = rmfield(UNIQUE_INSTANCE, obj.name);

        end % function

    end % methods

    %% Virtual Method
    methods(Abstract)

        % This methods is virtual and requires the child class to
        % implement. The normal constructor would go here instead of in the
        % public section of the class.
        obj = Instance(varargin)

    end % methods

end % classdef
