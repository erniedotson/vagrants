#!/bin/bash
#set -ex

###############################################################################
# Purpose    : Print error message and exit with error code 1
# Parameters : string - the message to print
# Returns    : N/A - terminates the script with error code 1
###############################################################################
die() { echo "$@" 1>&2 ; exit 1; }

###############################################################################
# Enable SSH
# Note: SSH already enabled in vagrant
###############################################################################
# In GUI Navigate to: System / Services / Services / SSHD / Enable

##############################################################################
# Add user to sudoers
# Note: vagrant user already a member of sudoers
##############################################################################
# Login as root
#    usermod -aG wheel username
#    visudo
# Uncomment the line for wheel group

##############################################################################
sudo yum check-update

##############################################################################
echo
echo "Script complete"