# Ernie's Vagrants

I'm a big fan of using [Vagrant VMs](https://www.vagrantup.com/) for development or just quick tests where I don't want to pollute my workstation with temporary software.

<!-- toc -->

- [Vagrants](#vagrants)
  * [CentOS 6](#centos-6)
  * [CentOS 7](#centos-7)
  * [CentOS 8](#centos-8)
  * [Ubuntu 14.04 LTS (Trusty Tahr) 64-bit](#ubuntu-1404-lts-trusty-tahr-64-bit)
  * [Ubuntu 16.04 LTS (Xenial Xerus) 64-bit](#ubuntu-1604-lts-xenial-xerus-64-bit)
  * [Ubuntu 18.04 LTS (Bionic Beaver) 64-bit](#ubuntu-1804-lts-bionic-beaver-64-bit)
  * [Ubuntu 20.04 LTS (Focal Fossa) 64-bit](#ubuntu-2004-lts-focal-fossa-64-bit)
  * [Windows 7 64-bit](#windows-7-64-bit)
  * [Windows 10](#windows-10)
- [Recommended Plugins](#recommended-plugins)
  * [Vagrant Multi-PuTTY plugin](#vagrant-multi-putty-plugin)
  * [Vagrant Reload plugin](#vagrant-reload-plugin)
  * [Vagrant VBGuest plugin](#vagrant-vbguest-plugin)
- [References](#references)

<!-- tocstop -->

## Vagrants

### CentOS 6

1. Start the VM: `vagrant up centos6`
1. SSH in: `vagrant ssh centos6` or `vagrant putty centos6`

### CentOS 7

1. Start the VM: `vagrant up centos7`
1. SSH in: `vagrant ssh centos7` or `vagrant putty centos7`

### CentOS 8

1. Start the VM: `vagrant up centos8`
1. SSH in: `vagrant ssh centos8` or `vagrant putty centos8`

### Ubuntu 14.04 LTS (Trusty Tahr) 64-bit

1. Start the VM: `vagrant up ubuntu14`
1. SSH in: `vagrant ssh ubuntu14` or `vagrant putty ubuntu14`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu14 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

### Ubuntu 16.04 LTS (Xenial Xerus) 64-bit

1. Start the VM: `vagrant up ubuntu16`
1. SSH in: `vagrant ssh ubuntu16` or `vagrant putty ubuntu16`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu16 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

### Ubuntu 18.04 LTS (Bionic Beaver) 64-bit

1. Start the VM: `vagrant up ubuntu18`
1. SSH in: `vagrant ssh ubuntu18` or `vagrant putty ubuntu18`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu18 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

### Ubuntu 20.04 LTS (Focal Fossa) 64-bit

**NOTE: At time of writing (September 27, 2020) attempts to use this box result in the VM hanging both Vagrant and Virtual Box Manager. This was seen on Windows 10 using Virtual Box 6.1.14r140239 and varant version Vagrant 2.2.9**

1. Start the VM: `vagrant up ubuntu20`
1. SSH in: `vagrant ssh ubuntu20` or `vagrant putty ubuntu20`

If you want a GUI Desktop (not recommended):
1. Install a GUI desktop: `vagrant provision ubuntu20 --provision-with gui`
1. Open Oracle VirtualBox Manager 'as an Administrator'.
1. Right click on the virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine.

### Windows 7 64-bit

Uses box: *opentable/win-7-professional-amd64-nocm*

1. `vagrant up win7`
1. `vagrant rdp win7`. Use username, *vagrant*, and password, *vagrant*.

### Windows 10

Uses box: *Microsoft/EdgeOnWindows10*

**NOTE: On or around April 10, 2020, it seems that the official `Microsoft/EdgeOnWindows10` box has been moved or removed from it's Azure cloud storage location. It remains unavailable as of writing (September 27, 2020). If you do not already have this box in your local vagrant box cache, you will get a 404 error attempting to download.**

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

## Recommended Plugins

### Vagrant Multi-PuTTY plugin

If you are on a Windows host, [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) is a must. It allows you to `vagrant putty` instead of `vagrant ssh`, opening a new PuTTY window.

### Vagrant Reload plugin

[Vagrant Reload plugin](https://github.com/aidanns/vagrant-reload) allows one to "Reload a VM as a provisioning step." I some cases I make use of this plugin in this Vagrantfile.

### Vagrant VBGuest plugin

[Vagrant VBGuest plugin](https://github.com/dotless-de/vagrant-vbguest) is handy to keep your guest VirtualBox guest additions in sync with your host.

*TIP:* Make sure on your host that your Guest Additions Extension Pack version matches the version of Virtual Box installed, otherwise you may see strange behavior when attempting to boot a guest vagrant.

## References

- [Vagrant](https://www.vagrantup.com/) - Development Environments Made Easy
- [Vagrant Plugins](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins) - A list of Vagrant Plugins
- [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) - This plugin allows you to use putty to ssh into VMs.
- [Vagrant Reload plugin](https://github.com/aidanns/vagrant-reload) - "Reload a VM as a provisioning step."
- [Vagrant VBGuest plugin](https://github.com/dotless-de/vagrant-vbguest) - automatically update VirtualBox guest additions if necessary
