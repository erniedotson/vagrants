# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'pathname'
require "open-uri"
require "fileutils"
require 'zip'

################################################################################
# Purpose    : Download a file from the web
# Paramaters : url - the URL to download
#              path - the path/file to save as
# Returns    : n/a
################################################################################
def download(url, path)
  case io = open(url)
  when StringIO then File.open(path, 'w') { |f| f.write(io) }
  when Tempfile then io.close; FileUtils.mv(io.path, path)
  end
end

################################################################################
# Purpose    : Extract a zip file
# Paramaters : file - the zip file to extract
#              destination - the destination to extract to
# Returns    : n/a
################################################################################
def extract_zip(file, destination)
  FileUtils.mkdir_p(destination)

  Zip::File.open(file) do |zip_file|
    zip_file.each do |f|
      fpath = File.join(destination, f.name)
      zip_file.extract(f, fpath) unless File.exist?(fpath)
    end
  end
end
################################################################################
# Ensure running 'As Administrator' on Windows
################################################################################
if Vagrant::Util::Platform.windows? then
  def running_in_admin_mode?
    (`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil?
  end

  unless running_in_admin_mode?
    puts "WARNING: To make use of symlinks to the host, Administrative "
    puts "         privileges are required to create symlinks (mklink.exe)."
    puts "         Try again from an Administrative command prompt.\n\n"
  end
end

################################################################################
# Check for arguments
################################################################################
$arg_up = false
$arg_win10 = false
for i in 0 ... ARGV.length
  if "#{ARGV[i]}" == "up"
    arg_up = true
  end
  if "#{ARGV[i]}" == "win10"
    arg_win10 = true
  end
end

################################################################################
# Function to check whether VM was already provisioned
################################################################################
def provisioned?(vm_name='default', provider='virtualbox')
  File.exists?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end
#Usage:  config.ssh.username = 'custom_username' if provisioned?

################################################################################
# Function to find path to Vagrantfile
################################################################################
def getVagrantFilePath()
  vagrant_dir = Dir.pwd
  done = false
  while (!done)
    if File.exists?(File.join(vagrant_dir, "Vagrantfile"))
      done = true
    else
      tmp = Pathname.new(vagrant_dir).parent.to_s
      if (vagrant_dir == tmp)
        # This shouldn't happen. It means we are at the root and didn't find
        # the Vagrantfile. Just set flag to avoid infinite loop
        done = true
      else
        vagrant_dir = tmp
      end
    end
  end
  return vagrant_dir
end

################################################################################
# Get the path to Vagrantfile
################################################################################
vagrantFilePath = getVagrantFilePath
#puts "vagrantFilePath returned: #{vagrantFilePath}"

################################################################################
# If we are up'ing win10, download and register the box, if necessary
################################################################################
if ( arg_up & arg_win10 )
  # For more/updated windows boxes, refer to:
  # https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/
  # Note: Boxes added from file cannot have a box version associated. We
  #       will append it to the name
  boxname = "win10-20190311"
  boxurl = "https://az792536.vo.msecnd.net/vms/VMBuild_20190311/Vagrant/MSEdge/MSEdge.Win10.Vagrant.zip"
  zipfile = "./MSEdge.Win10.Vagrant.zip"
  boxfile = "./MSEdge - Win10.box"

  boxlist = `vagrant box list`
  registered = boxlist.include? boxname
  if (!registered)
    if (!File.exists? boxfile)
      if (!File.exists? zipfile)
        puts "Downloading #{zipfile}..."
        download(boxurl, zipfile)
      # else zipfile already exists
      end
      puts "Extracting #{zipfile}..."
      extract_zip(zipfile, './')
      File.delete(zipfile)
    # else boxfile already exists
    end
    puts "Registering new vagrant box #{boxfile}..."
    if (!system("vagrant box add --provider virtualbox #{boxname} \"#{boxfile}\""))
      exit 1
    end
    File.delete(boxfile)
  end
  # else win10 box already registered
end

# Refrence: https://github.com/martinandersson/dev-mini/blob/master/Vagrantfile

VMCONFIGURATION = {
  name: 'ubuntu20',
  box: 'ubuntu/focal64',
}, {
  name: 'ubuntu18',
  box: 'ubuntu/bionic64',
}, {
  name: 'ubuntu16',
  box: 'ubuntu/xenial64',
}, {
  name: 'centos8',
  box: 'centos/8',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
}, {
  name: 'centos7',
  box: 'centos/7',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
}, {
  name: 'centos6',
  box: 'generic/centos6',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
}

################################################################################
# Configure Vagrant
################################################################################
Vagrant.configure("2") do |config|

  config.vagrant.plugins = [
    "nugrant",
    "vagrant-disksize",
    "vagrant-reload",
    "vagrant-vbguest"
  ]

  # Enable SSH Agent Forwarding
  config.ssh.forward_agent = true

  ##############################################################################
  # Loop through our VM configurations
  ##############################################################################
  VMCONFIGURATION.each do |vmconfig|
    config.vm.define "#{vmconfig[:name]}", autostart: false do |config|
      # config.vbguest.auto_update = false
      config.vm.box = "#{vmconfig[:box]}"
      config.vm.hostname = "#{vmconfig[:name]}"
      config.disksize.size = eval("config.user.vagrants.#{vmconfig[:name]}.disksize")
      config.vm.boot_timeout = eval("config.user.vagrants.#{vmconfig[:name]}.boot_timeout")
      config.vm.provider "virtualbox" do |vb|
        vb.cpus = eval("config.user.vagrants.#{vmconfig[:name]}.cpus")
        if eval("config.user.vagrants.#{vmconfig[:name]}.disable_audio")
          # Disable audio card to avoid interference with host audio
          vb.customize ["modifyvm", :id, "--audio", "none"]
        end
        if eval("config.user.vagrants.#{vmconfig[:name]}.enable_clipboard")
          # Enable bidirectional Clipboard
          vb.customize ["modifyvm", :id, "--clipboard",   "bidirectional"]
        end
        if eval("config.user.vagrants.#{vmconfig[:name]}.enable_draganddrop")
          # Enable bidirectional file drag and drop
          vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
        end
        vb.gui = eval("config.user.vagrants.#{vmconfig[:name]}.gui")
        #vb.memory = "2048"
        vb.memory = "#{eval("config.user.vagrants.#{vmconfig[:name]}.memory")}"

        #vb.customize ["modifyvm", :id, "--vram", "256"]
        vb.customize ["modifyvm", :id, "--vram", "#{eval("config.user.vagrants.#{vmconfig[:name]}.videomemory")}"]
      end

      unless vmconfig[:mounts].nil?
        vmconfig[:mounts].each do |mount|
          # config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
          config.vm.synced_folder mount[:hostPath], mount[:guestPath], type: mount[:type]
        end
      end

      config.vm.provision "ansible_local" do |ansible|
        # ansible.verbose = "vvv"
        ansible.playbook = "provisioning/default-playbook.yml"
        ansible.galaxy_roles_path = '/home/vagrant/.ansible/roles/'
        ansible.galaxy_role_file = 'provisioning/requirements.yml'
        ansible.galaxy_command = "ansible-galaxy collection install -r %{role_file}"
      end
      config.vm.provision :reload
      config.vm.provision "gui", type: "ansible_local", run: "never" do |ansible|
        # ansible.verbose = "vvv"
        ansible.playbook = "provisioning/gui-playbook.yml"
        ansible.galaxy_roles_path = '/home/vagrant/.ansible/roles/'
        ansible.galaxy_role_file = 'provisioning/requirements.yml'
        ansible.galaxy_command = "ansible-galaxy collection install -r %{role_file}"
      end
      config.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh #{vmconfig[:name]}'."
    end
  end

  ##############################################################################
  # Win10
  ##############################################################################
  config.vm.define "win10", autostart: false do |win10|
    # win10.vm.box = "Microsoft/EdgeOnWindows10"
    win10.vm.box = "win10-20190311"
    win10.vm.guest = :windows
    win10.vm.network :forwarded_port, guest: 5985, host: 5985, host_ip: "127.0.0.1", id: "winrm", auto_correct: true
    win10.vm.network :forwarded_port, host: 33389, guest: 3389, host_ip: "127.0.0.1", id: "rdp", auto_correct: true
    win10.vm.hostname = "win10"
    win10.disksize.size = config.user.vagrants.win10.disksize
    win10.vm.boot_timeout = config.user.vagrants.win10.boot_timeout
    win10.vm.provider "virtualbox" do |vb|
      vb.cpus = config.user.vagrants.win10.cpus
      if config.user.vagrants.win10.disable_audio
        # Disable audio card to avoid interference with host audio
        vb.customize ["modifyvm", :id, "--audio", "none"]
      end
      if config.user.vagrants.win10.enable_clipboard
        # Enable bidirectional Clipboard
        vb.customize ["modifyvm", :id, "--clipboard",   "bidirectional"]
      end
      if config.user.vagrants.win10.enable_draganddrop
        # Enable bidirectional file drag and drop
        vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      end
      vb.gui = config.user.vagrants.win10.gui
      #vb.memory = "2048"
      vb.memory = "#{config.user.vagrants.win10.memory}"

      #vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.customize ["modifyvm", :id, "--vram", "#{config.user.vagrants.win10.videomemory}"]
    end

    # Use Windows Remote Management instead of default SSH connections
    win10.vm.communicator = "winrm"
    # Note: Provision script will change the UN/PW in the to vagrant/vagrant
    #       and leave a breadcrumb indicating so. Check for that breadcrumb
    #       and determine which UN/PW to use.
    if (File.exist?(File.join(vagrantFilePath, '.vagrant/machines/win10/virtualbox/username')))
      win10.winrm.username = "vagrant"
    else
      win10.winrm.username = "IEUser"
    end
    if (File.exist?(File.join(vagrantFilePath, '.vagrant/machines/win10/virtualbox/userpass')))
      win10.winrm.password = "vagrant"
    else
      win10.winrm.password = "Passw0rd!"
    end

    win10.vm.provision "shell", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd
    SHELL
    win10.vm.provision "shell", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\provision_win10.cmd
    SHELL

    win10.vm.provision "extendfs", type: "shell", run: "never", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd
    SHELL

    win10.vm.post_up_message = "VM is ready. You can access by typing 'vagrant powershell win10' or 'vagrant rdp win10' and using uername 'IEUser' and password 'Passw0rd!'."
  end
end
