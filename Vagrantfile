# -*- mode: ruby -*-
# vi: set ft=ruby :

############################################################################
# Ensure running 'As Administrator' on Windows
############################################################################
if Vagrant::Util::Platform.windows? then
  def running_in_admin_mode?
    (`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil?
  end

  unless running_in_admin_mode?
    puts "This vagrant makes use of SymLinks to the host. On Windows, Administrative privileges are required to create symlinks (mklink.exe). Try again from an Administrative command prompt."
    exit 1
  end
end

############################################################################
# Check for required plugins - on 'vagrant up' only
############################################################################
if ARGV[0] == "up"
  required_plugins = %w( vagrant-reload vagrant-vbguest )
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      puts "Missing required plugin, #{plugin}. To install run command: vagrant plugin install #{plugin}"
      exit 1
    end
  end # required_plugins.each do
end

############################################################################
# Configure Vagrant
############################################################################
Vagrant.configure("2") do |config|

  #
  # CentOS 6
  #
  config.vm.define "centos6", autostart: false do |centos6|
    centos6.vm.box = "centos/6"
    # Periodically CentOS 'forgets' to install GuestAdditions in their monthly update of box version. Stick to the latest one we know works today.
    centos6.vm.box_version = "1611.01"
    centos6.vm.hostname = "centos6"
    centos6.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      #vb.memory = "2048"
      #vb.cpus = 2
    end

    # Problem: centos/6 box results in this error on Windows hosts: "rsync" could not be found on your PATH. Make sure that rsync is properly installed on your system and available on the PATH.
    # Resolution: Force it to use Virtualbox shared folders
    centos6.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    centos6.vm.provision "shell", name: "packages", privileged: false, inline: <<-SHELL
      /vagrant/scripts/provision_centos-6.sh
    SHELL
    centos6.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh centos6'."
  end

  #
  # CentOS 7
  #
  config.vm.define "centos7", autostart: false do |centos7|
    centos7.vm.box = "centos/7"
    # Periodically CentOS 'forgets' to install GuestAdditions in their monthly update of box version. Stick to the latest one we know works today.
    centos7.vm.box_version = "1706.02"
    centos7.vm.hostname = "centos7"
    centos7.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      #vb.memory = "2048"
      #vb.cpus = 2
    end

    # Problem: centos/7 box results in this error on Windows hosts: "rsync" could not be found on your PATH. Make sure that rsync is properly installed on your system and available on the PATH.
    # Resolution: Force it to use Virtualbox shared folders
    centos7.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    centos7.vm.provision "shell", inline: <<-SHELL
      /vagrant/scripts/provision_centos-7.sh
    SHELL
    centos7.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh centos7'."
  end

  #
  # Ubuntu 14.04 Trusty Tahr
  #
  config.vm.define "trusty64", autostart: false do |trusty64|
    trusty64.vm.box = "ubuntu/trusty64"
    trusty64.vm.hostname = "trusty64"
    trusty64.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      #vb.memory = "2048"
      #vb.cpus = 2
      #vb.customize ["modifyvm", :id, "--vram", "256"]
    end
    trusty64.vm.provision "shell", privileged: true, inline: <<-SHELL
      /vagrant/scripts/provision_ubuntu-trusty64.sh
    SHELL
    trusty64.vm.provision "gui", type: "shell", privileged: true, run: "never", inline: <<-SHELL
      /vagrant/scripts/provision_ubuntu-trusty64_gui.sh
    SHELL
    trusty64.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh trusty64'.\nIf you wish, you can install a GUI desktop by typing 'vagrant provision trusty64 --provision-with gui'."
  end

  #
  # Ubuntu 16.04 Trusty Tahr
  #
  config.vm.define "xenial64", autostart: false do |xenial64|
    xenial64.vm.box = "ubuntu/xenial64"
    xenial64.vm.hostname = "xenial64"
    xenial64.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      #vb.memory = "2048"
      #vb.cpus = 2
      #vb.customize ["modifyvm", :id, "--vram", "256"]
    end
    xenial64.vm.provision "shell", privileged: true, inline: <<-SHELL
      /vagrant/scripts/provision_ubuntu-xenial64.sh
    SHELL
    xenial64.vm.provision "gui", type: "shell", privileged: true, run: "never", inline: <<-SHELL
      /vagrant/scripts/provision_ubuntu-xenial64_gui.sh
    SHELL
    xenial64.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh xenial64'.\nIf you wish, you can install a GUI desktop by typing 'vagrant provision xenial64 --provision-with gui'."
  end

  #
  # Windows 7 x64
  #
  config.vm.define "win7", autostart: false do |win7|
    win7.vm.guest = :windows
    win7.vm.network :forwarded_port, guest: 5985, host: 5985, host_ip: "127.0.0.1", id: "winrm", auto_correct: true
    win7.vm.network :forwarded_port, host: 33389, guest: 3389, host_ip: "127.0.0.1", id: "rdp", auto_correct: true
    win7.windows.set_work_network = true
    win7.vm.communicator = "winrm"
    win7.winrm.username = "vagrant"
    win7.winrm.password = "vagrant"
    win7.vm.box = "opentable/win-7-professional-amd64-nocm" # UAC disabled, Requires install of deprecated plugin vagrant-windows OR modifiction of box Vagrantfile to
    win7.vm.synced_folder ".", "/vagrant"
    win7.vm.hostname = "win7"
    win7.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false

      # Customize the amount of memory on the VM:
      vb.memory = "3072"

      # Increase number of CPUs
      vb.cpus = 2

      # If using a GUI Desktop, increase video memory
      vb.customize ["modifyvm", :id, "--vram", "256"]
    end

    win7.vm.provision "shell", privileged: true, inline: <<-SHELL
      cmd.exe /c \\vagrant\\scripts\\provision_win7.cmd
    SHELL

    # Reboot required after installing .Net Framework (installed by Chocolatey)
    win7.vm.provision :reload

    # Continue provisioning...
    win7.vm.provision "shell", privileged: true, inline: <<-SHELL
      cmd.exe /c \\vagrant\\scripts\\provision_win7.cmd
    SHELL

    # Reboot required after installing kb2534366, kb2454826, kb2533552  (pre-req for SP1, KB976932)
    win7.vm.provision :reload

    # Continue provisioning...
    #win7.vm.provision "shell", privileged: true, inline: <<-SHELL
    #  cmd.exe /c \\vagrant\\scripts\\provision_win7.cmd
    #SHELL

    # Reboot required after installing xxx  (pre-req for SP1, KB976932)
    #win7.vm.provision :reload

    # Continue provisioning...
    #win7.vm.provision "shell", privileged: true, inline: <<-SHELL
    #  cmd.exe /c \\vagrant\\scripts\\provision_win7.cmd
    #SHELL

    win7.vm.post_up_message = "VM is ready. You can access by typing 'vagrant powershell win7' or 'vagrant rdp win7' and using uername 'vagrant' and password 'vagrant'."
  end

  #
  # Win10
  #
  config.vm.define "win10", autostart: false do |win10|
    win10.vm.box = "Microsoft/EdgeOnWindows10"
    win10.vm.guest = :windows
    win10.vm.network :forwarded_port, guest: 5985, host: 5985, host_ip: "127.0.0.1", id: "winrm", auto_correct: true
    win10.vm.network :forwarded_port, host: 33389, guest: 3389, host_ip: "127.0.0.1", id: "rdp", auto_correct: true
    win10.vm.hostname = "win10"
    win10.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      vb.memory = "4096"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--vram", "256"]
    end

    # Use Windows Remote Management instead of default SSH connections
    win10.vm.communicator = "winrm"
    win10.winrm.username = "IEUser"
    win10.winrm.password = "Passw0rd!"

    win10.vm.provision "shell", privileged: true, inline: <<-SHELL
      cmd.exe /c \\vagrant\\scripts\\provision_win10.cmd
    SHELL

    win10.vm.post_up_message = "VM is ready. You can access by typing 'vagrant powershell win10' or 'vagrant rdp win10' and using uername 'IEUser' and password 'Passw0rd!'."
  end
end
