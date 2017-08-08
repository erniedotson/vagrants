#!/bin/bash
set -ex

sudo apt-get update

# Fix for Visual Studio Code / Git Bash Display
grep -q -F 'LS_COLORS' /home/vagrant/.bashrc || echo 'export LS_COLORS="ow=01;36;40"' >> /home/vagrant/.bashrc

echo "Provision script has completed!"