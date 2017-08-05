#!/bin/bash
set -e

#
# Install GUI Desktop on Ubuntu Trusty 64
#
sudo apt-get install -y ubuntu-desktop
echo "Ubuntu GUI desktop has been installed. A reboot ('vagrant reload') is requried... sometimes 2 or 3 are required."