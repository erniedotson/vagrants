# Ernie's Vagrants

I'm a big fan of using [Vagrant VMs](https://www.vagrantup.com/) for development or just quick tests where I don't want to pollute my workstation with temporary software.

<!-- markdownlint-disable MD004 -->

<!-- toc -->

- [Getting Started](#getting-started)
  * [Install pre-requisites](#install-pre-requisites)
  * [Quick Start](#quick-start)
- [Vagrant Operating Systems](#vagrant-operating-systems)
  * [Ubuntu 26.04 LTS (Resolute Raccoon) 64-bit](#ubuntu-2604-lts-resolute-raccoon-64-bit)
  * [Ubuntu 24.04 LTS (Noble Numbat) 64-bit](#ubuntu-2404-lts-noble-numbat-64-bit)
  * [Ubuntu 22.04 LTS (Jammy Jellyfish) 64-bit](#ubuntu-2204-lts-jammy-jellyfish-64-bit)
  * [Ubuntu 20.04 LTS (Focal Fossa) 64-bit](#ubuntu-2004-lts-focal-fossa-64-bit)
  * [Ubuntu 18.04 LTS (Bionic Beaver) 64-bit](#ubuntu-1804-lts-bionic-beaver-64-bit)
  * [Ubuntu 16.04 LTS (Xenial Xerus) 64-bit](#ubuntu-1604-lts-xenial-xerus-64-bit)
  * [Debian 13](#debian-13)
  * [Debian 12](#debian-12)
  * [Rocky Linux 8](#rocky-linux-8)
  * [Rocky Linux 9](#rocky-linux-9)
  * [AlmaLinux 8](#almalinux-8)
  * [Windows 10](#windows-10)
  * [Windows 11](#windows-11)
- [Customizing the vagrant VM](#customizing-the-vagrant-vm)
  * [Adding a Desktop GUI](#adding-a-desktop-gui)
  * [Expanding the Disk Partition](#expanding-the-disk-partition)
- [Configuration System](#configuration-system)
- [SSH Configuration](#ssh-configuration)
- [Windows SSH Agent Setup](#windows-ssh-agent-setup)
- [Plugins](#plugins)
  * [Required Plugins](#required-plugins)
  * [Vagrant Multi-PuTTY plugin](#vagrant-multi-putty-plugin)
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

### Ubuntu 26.04 LTS (Resolute Raccoon) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu26 |
| Vagrant box | [bento/ubuntu-26.04](https://app.vagrantup.com/bento/boxes/ubuntu-26.04) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up ubuntu26`
2. Begin using the VM: `vagrant ssh ubuntu26`

### Ubuntu 24.04 LTS (Noble Numbat) 64-bit

| Name | Value |
| ---- | ----- |
| Vagrant name | ubuntu24 |
| Vagrant box | [bento/ubuntu-24.04](https://app.vagrantup.com/bento/boxes/ubuntu-24.04) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up ubuntu24`
2. Begin using the VM: `vagrant ssh ubuntu24`

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
2. Begin using the VM: `vagrant ssh ubuntu20`

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

### Debian 13

| Name | Value |
| ---- | ----- |
| Vagrant name | debian13 |
| Vagrant box | [bento/debian-13](https://app.vagrantup.com/bento/boxes/debian-13) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up debian13`
2. Begin using the VM: `vagrant ssh debian13`

### Debian 12

| Name | Value |
| ---- | ----- |
| Vagrant name | debian12 |
| Vagrant box | [generic/debian12](https://app.vagrantup.com/generic/boxes/debian12) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up debian12`
2. Begin using the VM: `vagrant ssh debian12`

### Rocky Linux 8

Rocky Linux is a 1:1 bug-for-bug compatible replacement for Red Hat Enterprise Linux (RHEL) 8.

| Name | Value |
| ---- | ----- |
| Vagrant name | rocky8 |
| Vagrant box | [generic/rocky8](https://app.vagrantup.com/generic/boxes/rocky8) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up rocky8`
2. Begin using the VM: `vagrant ssh rocky8`

### Rocky Linux 9

Rocky Linux is a 1:1 bug-for-bug compatible replacement for Red Hat Enterprise Linux (RHEL) 9.

| Name | Value |
| ---- | ----- |
| Vagrant name | rocky9 |
| Vagrant box | [bento/rockylinux-9](https://app.vagrantup.com/bento/boxes/rockylinux-9) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up rocky9`
2. Begin using the VM: `vagrant ssh rocky9`

### AlmaLinux 8

AlmaLinux is an ABI-compatible replacement for Red Hat Enterprise Linux (RHEL) 8.

| Name | Value |
| ---- | ----- |
| Vagrant name | alma8 |
| Vagrant box | [generic/alma8](https://app.vagrantup.com/generic/boxes/alma8) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up alma8`
2. Begin using the VM: `vagrant ssh alma8`

### Windows 10

| Name | Value |
| ---- | ----- |
| Vagrant name | win10 |
| Vagrant box | [gusztavvargadr/windows-10](https://app.vagrantup.com/gusztavvargadr/boxes/windows-10) |
| Credentials (e.g. for GUI Login) | vagrant/vagrant |

Steps to get up and running:

1. Create the VM: `vagrant up win10`
2. Due to the varying number of updates and rollups and their restart requirements, you may see a message indicating that a reboot is required. If you do, you should power off and start again to continue provisioning: `vagrant halt win10 && vagrant up win10 --provision`
3. Repeat step 2 until the VM comes up without errors.
4. Begin using the VM: `vagrant powershell win10` or `vagrant rdp win10`

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

### Expanding the Disk Partition

When you increase `disksize` in *vagrant.local.yml*, `vagrant-disksize` resizes the virtual disk file — but for `generic/*` and `bento/*` boxes the guest partition stays at its original size. Official `ubuntu/*` boxes handle this automatically via cloud-init and do not need the steps below.

For all other Linux VMs (debian12, debian13, rocky8, rocky9, alma8, ubuntu24, ubuntu26) and Windows VMs, after changing `disksize` you must expand the partition inside the guest:

```bash
vagrant provision <vagrant-name> --provision-with extendfs
```

For Linux this runs an Ansible playbook that installs `growpart`, expands the root partition (handling both plain partitions and LVM), and resizes the filesystem (ext4 or xfs). For Windows it uses `diskpart` to extend the volume.

Example workflow — doubling rocky8's disk:

```yaml
# vagrant.local.yml
vagrants:
    rocky8:
        disksize: 256GB
```

```bash
vagrant halt rocky8
vagrant up rocky8          # vagrant-disksize resizes the .vmdk
vagrant provision rocky8 --provision-with extendfs   # guest partition catches up
```

## Configuration System

This repository uses a built-in configuration system:

- *vagrant.defaults.yml* - Default settings for all VMs (committed to git)
- *vagrant.local.yml* - Optional user overrides (gitignored, create as needed)

No setup required - the system works with sensible defaults immediately after cloning.

## SSH Configuration

After each `vagrant up`, a trigger automatically writes an SSH config entry to `~/.ssh/vagrants/<vm-name>.<parent-dir>.config` and prepends `Include ~/.ssh/vagrants/*` to `~/.ssh/config`. This allows connecting directly with `ssh <vm-name>.<parent-dir>` without using `vagrant ssh`.

The config file is automatically removed when you run `vagrant destroy`.

## Windows SSH Agent Setup

On Windows, Git Bash and PowerShell/cmd can resolve to different `ssh.exe` binaries with separate agents, causing intermittent SSH failures during `vagrant up` provisioning and broken agent forwarding in `vagrant ssh` sessions. The following one-time setup unifies all terminals onto the Windows native OpenSSH agent so keys loaded once are available everywhere.

The following one-time setup is required on Windows.

**1. Enable the Windows native SSH agent service** (PowerShell as Administrator, run once):

```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

**2. Set PATH order so Windows native SSH comes first** — open *Edit environment variables for your account* from the Start menu, select **Path** in User variables, and move `C:\Windows\System32\OpenSSH` above any Git entries (e.g. `C:\Program Files\Git\usr\bin`, `C:\Program Files\Git\cmd`). Do the same in System variables if Git appears there too. This ensures cmd.exe and PowerShell use the native `ssh.exe` and `ssh-add.exe`, which can communicate with the native agent.

**3. Point Git Bash at the Windows native agent** — add to `~/.bashrc`:

```bash
export PATH="/c/Windows/System32/OpenSSH:$PATH"
export SSH_AUTH_SOCK="//./pipe/openssh-ssh-agent"
```

The PATH line ensures Git Bash also resolves to the native SSH binaries (which understand the Windows named pipe), and `SSH_AUTH_SOCK` points them at the running agent service.

**4. Add your keys to the unified agent** (once per reboot, or add to your shell profile):

```bash
ssh-add ~/.ssh/id_rsa   # adjust path to your key(s)
```

After completing setup, `ssh-add -L` from any terminal (Git Bash, cmd, PowerShell) should list your loaded keys. Inside a `vagrant ssh` session, `ssh-add -l` should show the same keys forwarded from the host.

## Plugins

### Required Plugins

The following plugins are declared in the Vagrantfile and auto-installed on first `vagrant up`:

- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize) - Resize the disk of a Vagrant VM
- [vagrant-reload](https://github.com/aidanns/vagrant-reload) - Reload a VM as a provisioning step

### Vagrant Multi-PuTTY plugin

If you are on a Windows host, [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) is a must. It allows you to `vagrant putty` instead of `vagrant ssh`, opening a new PuTTY window.

## Troubleshooting

### Configuration Issues

**PROBLEM:** Configuration values not being applied or errors loading configuration.

**CAUSE:** Issues with *vagrant.local.yml* syntax or structure.

**SOLUTION:** Verify your *vagrant.local.yml* follows proper YAML syntax and structure. Reference *vagrant.defaults.yml* for the correct format. The system works with defaults if no local config file exists.

## References

- [Vagrant](https://www.vagrantup.com/) - Development Environments Made Easy
- [Vagrant Plugins](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins) - A list of Vagrant Plugins
- [Vagrant Multi-PuTTY plugin](https://github.com/nickryand/vagrant-multi-putty) - This plugin allows you to use putty to ssh into VMs.
- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize) - Resize the disk of a Vagrant VM
- [vagrant-reload](https://github.com/aidanns/vagrant-reload) - Reload a VM as a provisioning step
- [VirtualBox](https://www.virtualbox.org) - VirtualBox is a general-purpose full virtualizer for x86 hardware
