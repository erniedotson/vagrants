# vagrants

## CentOS 6

1. Start the VM: `vagrant up centos6`
1. SSH in: `vagrant ssh centos6` or `vagrant putty centos6`

## CentOS 7

1. Start the VM: `vagrant up centos7`
1. SSH in: `vagrant ssh centos7` or `vagrant putty centos7`

## Ubuntu 14.04 LTS (Trusty Tahr) 64-bit

1. Start the VM: `vagrant up trusty64`
1. SSH in: `vagrant ssh trusty64` or `vagrant putty trusty64`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision trusty64 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the win10 virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

## Ubuntu 16.04 LTS (Xenial Xerus) 64-bit

1. Start the VM: `vagrant up xenial64`
1. SSH in: `vagrant ssh xenial64` or `vagrant putty xenial64`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision xenial64 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the win10 virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

## Windows 7 64-bit

Uses box: *opentable/win-7-professional-amd64-nocm*

1. `vagrant up win7`
1. `vagrant rdp win7`. Use username, *vagrant*, and password, *vagrant*.


## Windows 10

Uses box: *Microsoft/EdgeOnWindows10*

1. Create the vagrant VM by performing the following on the host computer:
    1. Execute the command `vagrant up win10`. This will create the VM and start it for you.
    1. After some time, you will see an error that Vagrant was unable to communicate with the machine. This is because Microsoft did not properly configure the 'box' for remote management. We will need to do this manually.
1. Configure Remote Management on the guest VM:
    1. **On the host**: Open Oracle VirtualBox Manager 'as an Administrator'.
    1. **On the host**: Right click on the win10 virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine. The virtual machine should already be logged in.
    1. **On the guest**: In Explorer, browse to `\\vboxsvr\vagrant\scripts`
    1. **On the guest**: Execute the script `vagrant_Microsoft-EdgeOnWindows10_bootstrap.cmd` 'as Administrator'. The guest will be configured for WinRM and RDP and then powered off.
    1. *Optional:* **On the host**: Close the VirtualBox Manager window.
1. Perform another `vagrant up win10` command and this time vagrant will begin provisioning the guest.
1. `vagrant rdp win10` to connect, etc. etc. Use username, *vagrant*, and password, *vagrant*.