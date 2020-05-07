#!/bin/bash
set -e

die() { echo "$*" 1>&2 ; exit 1; }

if grep "ubuntu" "/etc/os-release" &>/dev/null ; then

    # Tested on Ubuntu 18.04, 16.04, 14.04

    sudo apt-get update || die "ERROR: Failed to update apt"
    sudo apt-get -y install ubuntu-desktop || die "ERROR: Failed to install package ubuntu-desktop"
    init 5
elif grep "centos" "/etc/os-release" &>/dev/null ; then

    # Tested on CentOS 8, 7

    sudo yum -y groupinstall "Server with GUI" || die "ERROR: Failed to groupinstall 'Server with GUI'"
    sudo systemctl set-default graphical || die "ERROR: Failed to set-default graphical"
    sudo init 5
elif grep "CentOS release 6" "/etc/centos-release" &>/dev/null ; then

    # Tested on CentOS 6

    sudo yum -y groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts" || die "ERROR: Failed to install Desktop packages"
    # General Purpose Desktop step is not required,
    # but provides a few basic applications which are useful
    sudo yum -y groupinstall "General Purpose Desktop" || die "ERROR: Failed to install Additional Desktop packages"
    sudo sed -i 's/id:3:initdefault:/id:5:initdefault:/g' "/etc/inittab" || die "ERROR: Failed to set X11 mode in inittab"
    sudo init 5
else
    die "Platform not supported - halting GUI installation."
fi

echo ""
echo "GUI desktop has been installed. A reboot ('vagrant reload') may be required."
