# Ernie's Vagrants

I'm a big fan of using [Vagrant VMs](https://www.vagrantup.com/) for development or just quick tests where I don't want to pollute my workstation with temporary software.

<!-- markdownlint-disable MD004 -->

<!-- toc -->

- [Getting Started](#getting-started)
  * [Install pre-requisites](#install-pre-requisites)
  * [Quick Start](#quick-start)
- [Vagrant Operating Systems](#vagrant-operating-systems)
  * [Ubuntu 22.04 LTS (Jammy Jellyfish) 64-bit](#ubuntu-2204-lts-jammy-jellyfish-64-bit)
  * [Ubuntu 20.04 LTS (Focal Fossa) 64-bit](#ubuntu-2004-lts-focal-fossa-64-bit)
  * [Ubuntu 18.04 LTS (Bionic Beaver) 64-bit](#ubuntu-1804-lts-bionic-beaver-64-bit)
  * [Ubuntu 16.04 LTS (Xenial Xerus) 64-bit](#ubuntu-1604-lts-xenial-xerus-64-bit)
  * [Debian 12](#debian-12)
  * [Debian 11](#debian-11)
  * [Debian 10](#debian-10)
  * [CentOS 8 Stream](#centos-8-stream)
  * [CentOS 8 -- DEPRECATED](#centos-8----deprecated)
  * [CentOS 7](#centos-7)
  * [CentOS 6](#centos-6)
  * [Windows 10](#windows-10)
  * [Windows 11](#windows-11)
- [Customizing the vagrant VM](#customizing-the-vagrant-vm)
  * [Adding a Desktop GUI](#adding-a-desktop-gui)
- [Recommended Plugins](#recommended-plugins)
  * [Configuration System](#configuration-system)
  * [Vagrant Multi-PuTTY plugin](#vagrant-multi-putty-plugin)
  * [Vagrant Reload plugin](#vagrant-reload-plugin)
  * [Vagrant VBGuest plugin](#vagrant-vbguest-plugin)
- [Troubleshooting](#troubleshooting)
  * [Configuration Issues](#configuration-issues)
- [References](#references)

<!-- tocstop -->

<!-- markdownlint-enable MD004 -->

## Getting Started

### Install pre-requisites

Care has been taken to write everything in a platform-independent way, but development is done primarily on Windows inside of Git Bash. If something doesn't work quite right, try that environment.

- Install VirtualBox
- Install VirtualBox Extension Pack
- Ensure the version matches the version of VirtualBox
- Install Vagrant

### Quick Start

1. Clone the repo: `git clone https://github.com/erniedotson/vagrants.git`
1. Optionally create *vagrant.local.yml* to customize VM settings
1. Run vagrant status to get a list of *vagrant-name*s: `vagrant status`
1. Vagrant up your OS of choice: `vagrant up <vagrant-name>`
1. See table below for info on the Vagrants provided

## Vagrant Operating Systems

### Ubuntu 22.04 LTS (Jammy Jellyfish) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu22 |
| Vagrant box | [ubuntu/jammy64](https://app.vagrantup.com/ubuntu/boxes/jammy64) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up ubuntu22`
2. Begin using the VM: `vagrant ssh ubuntu22`

### Ubuntu 20.04 LTS (Focal Fossa) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu20 |
| Vagrant box | [ubuntu/focal64](https://app.vagrantup.com/ubuntu/boxes/focal64) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up ubuntu20`
2. You may encounter an error similar to:

    ```text
    VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel
    modules.  This may take a while.
    VirtualBox Guest Additions: To build modules for other installed kernels, run
    VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup <version>
    VirtualBox Guest Additions: or
    VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup all
    VirtualBox Guest Additions: Kernel headers not found for target kernel
    5.4.0-80-generic. Please install them and execute
      /sbin/rcvboxadd setup
    VirtualBox Guest Additions: Running kernel modules will not be replaced until
    the system is restarted
    Restarting VM to apply changes...
    ==> ubuntu20: Attempting graceful shutdown of VM...
    ==> ubuntu20: Booting VM...
    ==> ubuntu20: Waiting for machine to boot. This may take a few minutes...
    ==> ubuntu20: Machine booted and ready!
    ==> ubuntu20: Checking for guest additions in VM...
    ==> ubuntu20: Setting hostname...
    ==> ubuntu20: Mounting shared folders...
        ubuntu20: /vagrant => E:/work/my/vagrants
    Vagrant was unable to mount VirtualBox shared folders. This is usually
    because the filesystem "vboxsf" is not available. This filesystem is
    made available via the VirtualBox Guest Additions and kernel module.
    Please verify that these guest additions are properly installed in the
    guest. This is not a bug in Vagrant and is usually caused by a faulty
    Vagrant box. For context, the command attempted was:

    mount -t vboxsf -o uid=1000,gid=1000,_netdev vagrant /vagrant

    The error output from the command was:

    : Invalid argument
    ```

    **CAUSE:** This is caused because by the *VirtualBox Guest Additions* are not present in the guest VM but they are required to share folders between the host and the guest. The *vagrant-vbguest* plugin attempts to install the *VirtualBox Guest Additions* but fails to do so because the necessary packages are not present on the guest VM.

    **SOLUTION:** To resolve the issue you need to install the necessary packages.

    ```bash
    vagrant ssh ubuntu20 -c 'sudo apt-get -y install build-essential linux-headers-`uname -r` dkms'
    vagrant reload ubuntu20 --provision
    ```

3. Begin using the VM: `vagrant ssh ubuntu20`

### Ubuntu 18.04 LTS (Bionic Beaver) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu18 |
| Vagrant box | [ubuntu/bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

1. Create the VM: `vagrant up ubuntu18`
2. Begin using the VM: `vagrant ssh ubuntu18`

### Ubuntu 16.04 LTS (Xenial Xerus) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu16 |
| Vagrant box | [ubuntu/xenial64](https://app.vagrantup.com/ubuntu/boxes/xenial64) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

1. Create the VM: `vagrant up ubuntu16`
2. Begin using the VM: `vagrant ssh ubuntu16`

### Debian 12

| Name | Value |
| ---- | ----- |
| Vagrant name | debian12 |
| Vagrant box | [generic/debian12](https://app.vagrantup.com/generic/boxes/debian12) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up debian12`
2. Begin using the VM: `vagrant ssh debian12`

### Debian 11

| Name | Value |
| ---- | ----- |
| Vagrant name | debian11 |
| Vagrant box | [generic/debian11](https://app.vagrantup.com/generic/boxes/debian11) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up debian11`
2. Begin using the VM: `vagrant ssh debian11`

### Debian 10

| Name | Value |
| ---- | ----- |
| Vagrant name | debian10 |
| Vagrant box | [generic/debian10](https://app.vagrantup.com/generic/boxes/debian10) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up debian10`
2. Begin using the VM: `vagrant ssh debian10`

### CentOS 8 Stream

| Name | Value |
| ---- | ----- |
| Vagrant name | centos8s |
| Vagrant box | [generic/centos8s](https://app.vagrantup.com/generic/boxes/centos8s) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up centos8`
2. Begin using the VM: `vagrant ssh centos8s`

### CentOS 8 -- DEPRECATED

This vagrant is deprecated and will be removed soon. You should use the centos8s one instead.

| Name | Value |
| ---- | ----- |
| Vagrant name | centos8 |
| Vagrant box | [centos/8](https://app.vagrantup.com/centos/boxes/8) |
| Credentials (e.g. for GUI Login) | root/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up centos8`
2. You may encounter an error similar to:

    ```text
    Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist
    ```

    **CAUSE:** CentOS 8 is [EOL on December 31, 2021](https://www.centos.org/centos-linux-eol/).

    **SOLUTION:** Migrate to CentOS Stream 8.

    ```bash
    vagrant ssh centos8 -c 'sudo dnf --disablerepo "*" --enablerepo=extras swap centos-linux-repos centos-stream-repos -y'
    vagrant ssh centos8 -c 'sudo dnf distro-sync -y'
    vagrant reload centos8 --provision
    ```

3. You may encounter an error similar to:

    ```text
    ==> centos8: Checking for guest additions in VM...
        centos8: No guest additions were detected on the base box for this VM! Guest
        centos8: additions are required for forwarded ports, shared folders, host only
        centos8: networking, and more. If SSH fails on this machine, please install
        centos8: the guest additions and repackage the box to continue.
        centos8:
        centos8: This is not an error message; everything may continue to work properly,
        centos8: in which case you may ignore this message.
    The following SSH command responded with a non-zero exit status.
    Vagrant assumes that this means the command failed!

    umount /mnt

    Stdout from the command:



    Stderr from the command:

    umount: /mnt: not mounted.
    ```

    **CAUSE:** This is caused because by the *VirtualBox Guest Additions* are not present in the guest VM but they are required to share folders between the host and the guest. The *vagrant-vbguest* plugin attempts to install the *VirtualBox Guest Additions* but fails to do so because the necessary packages are not present on the guest VM.

    **SOLUTION:** To resolve the issue you need to install the necessary packages.

    ```bash
    vagrant ssh centos8 -c 'sudo yum update -y'
    vagrant reload centos8 --provision
    ```

4. Begin using the VM: `vagrant ssh centos8`

### CentOS 7

| Name | Value |
| ---- | ----- |
| Vagrant name | centos7 |
| Vagrant box | [centos/7](https://app.vagrantup.com/generic/boxes/centos7) |
| Credentials (e.g. for GUI Login) | root/vagrant |

1. Create the VM: `vagrant up centos7`
2. You may encounter an error similar to:

    ```text
    ==> centos6: Mounting shared folders...
        centos6: /vagrant => E:/work/my/vagrants
    Vagrant was unable to mount VirtualBox shared folders. This is usually
    because the filesystem "vboxsf" is not available. This filesystem is
    made available via the VirtualBox Guest Additions and kernel module.
    Please verify that these guest additions are properly installed in the
    guest. This is not a bug in Vagrant and is usually caused by a faulty
    Vagrant box. For context, the command attempted was:

    mount -t vboxsf -o uid=500,gid=500,_netdev vagrant /vagrant

    The error output from the command was:

    /sbin/mount.vboxsf: mounting failed with the error: Invalid argument
    ```

    To resolve it (end prevent the libselinux-python error below) enter the following commands:

    ```bash
    vagrant ssh centos7 -c 'sudo yum update -y'
    vagrant reload centos7 --provision
    ```

3. Begin using the VM: `vagrant ssh centos7`

### CentOS 6

| Name | Value |
| ---- | ----- |
| Vagrant name | centos6 |
| Vagrant box | [generic/centos6](https://app.vagrantup.com/generic/boxes/centos6) |
| Credentials (e.g. for GUI Login) | root/vagrant |

The offical [centos/6](https://app.vagrantup.com/generic/boxes/centos6) box now redirects to [generic/centos6](https://app.vagrantup.com/generic/boxes/centos6).

Steps to get up and running:

1. Create the VM: `vagrant up centos6`
2. You may encounter an error similar to:

    ```text
    ==> centos6: Mounting shared folders...
        centos6: /vagrant => E:/work/my/vagrants
    Vagrant was unable to mount VirtualBox shared folders. This is usually
    because the filesystem "vboxsf" is not available. This filesystem is
    made available via the VirtualBox Guest Additions and kernel module.
    Please verify that these guest additions are properly installed in the
    guest. This is not a bug in Vagrant and is usually caused by a faulty
    Vagrant box. For context, the command attempted was:

    mount -t vboxsf -o uid=500,gid=500,_netdev vagrant /vagrant

    The error output from the command was:

    /sbin/mount.vboxsf: mounting failed with the error: Invalid argument
    ```

    To resolve it (end prevent the libselinux-python error below) enter the following commands:

    ```bash
    vagrant ssh centos6 -c 'sudo yum update -y && sudo yum install -y libselinux-python'
    vagrant reload centos6 --provision
    ```

3. You may encounter an error similar to:

    ```text
    fatal: [centos6]: FAILED! => {"changed": false, "msg": "Aborting, target uses selinux but python bindings (libselinux-python) aren't installed!"}
    ```

    To resolve it enter the following commands:

    ```bash
    vagrant ssh centos6 -c 'sudo yum update -y && sudo yum install -y libselinux-python'
    vagrant reload centos6 --provision
    ```

4. Begin using the VM: `vagrant ssh centos6`

### Windows 10

| Name | Value |
| ---- | ----- |
| Vagrant name | win10 |
| Vagrant box | [Microsoft's Edge Developer Windows 10 vagrant image](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/) |
| Credentials (e.g. for GUI Login) | Initial: IEUser/Passw0rd!<br/>After provisioning: vagrant/vagrant |

On or around April 10, 2020, it seems that the official [Microsoft/EdgeOnWindows10](https://app.vagrantup.com/Microsoft/boxes/EdgeOnWindows10) box has been moved or removed from it's Azure cloud storage location. It remains unavailable as of writing (September 28, 2020). If you do not already have this box in your local vagrant box cache, you will get a 404 error attempting to download.

Instead, this `win10` vagrant will download [Microsoft's Edge Developer Windows 10 vagrant image](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/) and import it into the vagrant box list.

1. Create the vagrant VM by performing the following on the host computer:
    1. Execute the command `vagrant up win10`. This will create the VM and start it for you.
    1. After some time, you will see an error that Vagrant was unable to communicate with the machine. This is because Microsoft did not properly configure the 'box' for remote management. We will need to do this manually.
1. Configure Remote Management on the guest VM:
    1. **On the host**: Open Oracle VirtualBox Manager 'as an Administrator'.
    1. **On the host**: Right click on the win10 virtual machine that vagrant has created for you and click `Show` from the context menu. This will show you the console of the virtual machine. If the guest is not already logged in use `IEUser` for the username and `Passw0rd!` for the password.
    1. **On the guest**: In Explorer, browse to `\\vboxsvr\vagrant\scripts`
    1. **On the guest**: Execute the script `vagrant_Microsoft-EdgeOnWindows10_bootstrap.cmd` 'as Administrator'. The guest will be configured for WinRM and RDP and then powered off. The username and password will both be changed to `vagrant`
    1. *Optional:* **On the host**: Close the VirtualBox Manager window.
1. Perform another `vagrant up win10` command and this time vagrant will begin provisioning the guest.
1. `vagrant rdp win10` to connect, etc. etc. Use username, *vagrant*, and password, *vagrant*.

### Windows 11

| Name | Value |
| ---- | ----- |
| Vagrant name | win11 |
| Vagrant box | [gusztavvargadr/windows-11](https://app.vagrantup.com/gusztavvargadr/boxes/windows-11) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up win11`
2. Begin using the VM: `vagrant rdp win11`

## Customizing the vagrant VM

The *vagrant.local.yml* file contains parameters for customizing each vagrant. You can create this file to override defaults in *vagrant.defaults.yml* to increase CPUs, RAM, or disk size, or more. Once you modify the *vagrant.local.yml* file you should re-run the provisioners by doing the following:

```bash
vagrant halt <vagrant-name>
vagrant up <vagrant-name> --provision
```

### Adding a Desktop GUI

By default these vagrants are designed to be used *headless* and therefore most do not have a Desktop GUI installed and are set to hide the Console Window when they boot up.

To add a Desktop GUI first bring the vagrant up in it's default headless state. Then perform the following:

Change the appropriate `gui: false` entry in the *vagrant.local.yml* file to `gui: true` to inform Virtualbox to display the console window when the VM boots.

Increase the `videomemory` option in the *vagrant.local.yml* file. Many are set to use 4 MB of video memory which just isn't enough for a Desktop GUI. I recommend bumping this up to 128 or 256 MB.

Example of changes below:

```diff
    ubuntu20:
        cpus: 2
        disable_audio: true
        disksize: 64GB
        enable_clipboard: false
        enable_draganddrop: false
-       gui: false
+       gui: true
        memory: 1024
-       videomemory: 4
+       videomemory: 256
```

Once you've made changes to the *vagrant.local.yml* file, you can install the
Desktop GUI by running `vagrant provision <vagrant-name> --provision-with gui`

Once that installs the Desktop GUI, it will likely take one more reboot for the GUI to be enabled: `vagrant reload <vagrant-name>`

## Recommended Plugins

### Configuration System

This repository uses a built-in configuration system:

- *vagrant.defaults.yml* - Default settings for all VMs (committed to git)
- *vagrant.local.yml* - Optional user overrides (gitignored, create as needed)

No setup required - the system works with sensible defaults immediately after cloning.

### Vagrant Multi-PuTTY plugin

If you are on a Windows host, [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) is a must. It allows you to `vagrant putty` instead of `vagrant ssh`, opening a new PuTTY window.

### Vagrant Reload plugin

[Vagrant Reload plugin](https://github.com/aidanns/vagrant-reload) allows one to "Reload a VM as a provisioning step." I some cases I make use of this plugin in this Vagrantfile.

### Vagrant VBGuest plugin

[Vagrant VBGuest plugin](https://github.com/dotless-de/vagrant-vbguest) is handy to keep your guest VirtualBox guest additions in sync with your host.

*TIP:* Make sure on your host that your Guest Additions Extension Pack version matches the version of Virtual Box installed, otherwise you may see strange behavior when attempting to boot a guest vagrant.

## Troubleshooting

### Configuration Issues

**PROBLEM:** Configuration values not being applied or errors loading configuration.

**CAUSE:** Issues with *vagrant.local.yml* syntax or structure.

**SOLUTION:** Verify your *vagrant.local.yml* follows proper YAML syntax and structure. Reference *vagrant.defaults.yml* for the correct format. The system works with defaults if no local config file exists.

## References

- [Vagrant](https://www.vagrantup.com/) - Development Environments Made Easy
- [Vagrant Plugins](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins) - A list of Vagrant Plugins
- [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) - This plugin allows you to use putty to ssh into VMs.
- [Vagrant Reload plugin](https://github.com/aidanns/vagrant-reload) - "Reload a VM as a provisioning step."
- [Vagrant VBGuest plugin](https://github.com/dotless-de/vagrant-vbguest) - automatically update VirtualBox guest additions if necessary
- [VirtualBox](https://www.virtualbox.org) - VirtualBox is a general-purpose full virtualizer for x86 hardware
