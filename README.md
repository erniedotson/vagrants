# vagrants

<!-- toc -->

- [CentOS 6](#centos-6)
- [CentOS 7](#centos-7)
- [CentOS 8](#centos-8)
- [Ubuntu 14.04 LTS (Trusty Tahr) 64-bit](#ubuntu-1404-lts-trusty-tahr-64-bit)
- [Ubuntu 16.04 LTS (Xenial Xerus) 64-bit](#ubuntu-1604-lts-xenial-xerus-64-bit)
- [Ubuntu 18.04 LTS (Bionic Beaver) 64-bit](#ubuntu-1804-lts-bionic-beaver-64-bit)
- [Windows 7 64-bit](#windows-7-64-bit)
- [Windows 10](#windows-10)

<!-- tocstop -->

## CentOS 6

1. Start the VM: `vagrant up centos6`
1. SSH in: `vagrant ssh centos6` or `vagrant putty centos6`

## CentOS 7

1. Start the VM: `vagrant up centos7`
1. SSH in: `vagrant ssh centos7` or `vagrant putty centos7`

## CentOS 8

1. Start the VM: `vagrant up centos8`
1. SSH in: `vagrant ssh centos8` or `vagrant putty centos8`

## Ubuntu 14.04 LTS (Trusty Tahr) 64-bit

1. Start the VM: `vagrant up ubuntu14`
1. SSH in: `vagrant ssh ubuntu14` or `vagrant putty ubuntu14`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu14 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

## Ubuntu 16.04 LTS (Xenial Xerus) 64-bit

1. Start the VM: `vagrant up ubuntu16`
1. SSH in: `vagrant ssh ubuntu16` or `vagrant putty ubuntu16`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu16 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

## Ubuntu 18.04 LTS (Bionic Beaver) 64-bit

1. Start the VM: `vagrant up ubuntu18`
1. SSH in: `vagrant ssh ubuntu18` or `vagrant putty ubuntu18`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu18 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

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
