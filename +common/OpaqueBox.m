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

    %% Virtual Properties
    properties (Abstract)

        % ======================================================================
        %  Highly Complicated systems will inevitably be linked in some
        %  fashion. The variable map is used to remap box specific
        %  variables so that boxes are more manuverable
        % ======================================================================
        variable_map

    end % properties

    %% Virtual Methods
    methods (Abstract)

        % ======================================================================
        % Debug is used for plotting, printing verbose, etc.
        % ======================================================================
        debug(obj)

        % ======================================================================
        % Run is the function that runs the system.
        % ======================================================================
        run(obj)

        % ======================================================================
        % Validate ensures that box contains necessary components to run the
        % system. It also allows for the 
        % ======================================================================
        validate(obj)

    end % methods

end % classdef