#!/bin/bash
set -e

# Fix for Visual Studio Code / Git Bash Display
# Note: During default provisioner we are running as root, not vagrant user
if [ -f "/home/vagrant/.bashrc" ]; then
    grep -q -F 'LS_COLORS' "/home/vagrant/.bashrc" || echo 'export LS_COLORS="ow=01;36;40"' >> "/home/vagrant/.bashrc"
fi

echo "Provision script has completed!"
