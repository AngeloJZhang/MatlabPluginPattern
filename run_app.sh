#!/bin/bash
# This script enables the running of the MATLAB application via a remote server
# and provides the terminal output. This is intended to be used in the case that
# the user cannot create a MATLAB container. MATLAB must be in the env path, in
# your remote machine to be able to run this command.

matlab -nodesktop -nosplash -nojvm -r "run('Application')"