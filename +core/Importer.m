function symlink(link_dest, link_source)
% ==============================================================================
%  This function create a symlink by calling system commands.
% ==============================================================================

% 

% Ensure the paths are valid.
if exist(link_source, "file")
    options = "/d";

elseif exist(link_source, "dir")
    options = "";

else
    error("File or Dir %s does not exist.", link_source);

end % if


% Check for the system OS.
if ismac
    % TODO : I have never used mac

elseif isunix
    % TODO : Test on linux

elseif ispc
    link_cmd = sprintf("mklink %s %s %s", options, link_dest, link_source);

else
    error('Platform not supported')

end % if

% Run the command.
[status, stdout] = system(link_cmd);

% 1 means exited out ungracefully.
if status == 1
    error("Command Failed : %s", stdout);

end % if

end % function