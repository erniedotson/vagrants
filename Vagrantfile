# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'pathname'
require "open-uri"
require "fileutils"
require 'zip'
require 'yaml'

################################################################################
# Purpose    : Deep merge two hashes (for configuration merging)
# Parameters : defaults - the default configuration hash
#              overrides - the user override hash
# Returns    : merged hash with overrides taking precedence
################################################################################
def deep_merge(defaults, overrides)
  return defaults if overrides.nil?
  return overrides if defaults.nil?

  defaults.merge(overrides) do |key, default_val, override_val|
    if default_val.is_a?(Hash) && override_val.is_a?(Hash)
      deep_merge(default_val, override_val)
    else
      override_val
    end
  end
end

################################################################################
# Purpose    : Load user configuration with defaults fallback
# Parameters : none
# Returns    : configuration hash with user overrides merged over defaults
################################################################################
def load_user_config
  # Load defaults from defaults file
  defaults = {}
  if File.exist?('vagrant.defaults.yml')
    defaults = YAML.load_file('vagrant.defaults.yml') || {}
  end

  # Load user overrides if file exists
  user_config = {}
  if File.exist?('vagrant.local.yml')
    user_config = YAML.load_file('vagrant.local.yml') || {}
  end

  # Merge user config over defaults
  return deep_merge(defaults, user_config)
end

################################################################################
# Purpose    : Get configuration value for a VM with fallback to defaults
# Parameters : vm_name - the name of the VM
#              key - the configuration key to retrieve
#              default - fallback value if not found
# Returns    : configuration value
################################################################################
def get_vm_config(vm_name, key, default = nil)
  value = USER_CONFIG.dig('vagrants', vm_name.to_s, key.to_s)
  return value unless value.nil?
  return default
end

################################################################################
# Purpose    : Detect the active Vagrant provider
# Parameters : none
# Returns    : provider name as string
################################################################################
def get_active_provider
  # Check command line arguments for provider
  provider = nil
  for i in 0 ... ARGV.length
    if ARGV[i] == "--provider" && i + 1 < ARGV.length
      provider = ARGV[i + 1]
      break
    elsif ARGV[i].start_with?("--provider=")
      provider = ARGV[i].split("=", 2)[1]
      break
    end
  end

  # Default to virtualbox if no provider specified
  return provider || "virtualbox"
end

################################################################################
# Purpose    : Configure disk size based on provider
# Parameters : config - Vagrant config object
#              vm_name - the name of the VM
#              disksize - desired disk size (e.g., "40GB")
# Returns    : none
################################################################################
def configure_disk_size(config, vm_name, disksize)
  provider = get_active_provider

  case provider
  when "virtualbox"
    # Use vagrant-disksize plugin for VirtualBox
    config.disksize.size = disksize
  when "hyperv"
    # Use native Vagrant disk configuration for Hyper-V
    config.vm.disk :disk, size: disksize, primary: true
  else
    # Try vagrant-disksize plugin as fallback, but warn
    puts "WARNING: Provider '#{provider}' may not support disksize configuration"
    config.disksize.size = disksize if defined?(config.disksize)
  end
end

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
# Function to check whether VM was already provisioned
################################################################################
def provisioned?(vm_name='default', provider='virtualbox')
  File.exist?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end
#Usage:  config.ssh.username = 'custom_username' if provisioned?

################################################################################
# Function to find path to Vagrantfile
################################################################################
def getVagrantFilePath()
  vagrant_dir = Dir.pwd
  done = false
  while (!done)
    if File.exist?(File.join(vagrant_dir, "Vagrantfile"))
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
# Purpose    : Get full name and path of ssh config in home dir
#            : provided name
# Paramaters : none
# Returns    : full name and path to ssh config file - it is presumed to exist
################################################################################
def getSSHConfigFilePath()
  return File.join(ENV['HOME'], ".ssh/config")
end

################################################################################
# Purpose    : Get full name and path of vagrant ssh-config file based on
#            : provided name
# Paramaters : name - the name of the vagrant
# Returns    : full name and path to vagrant ssh-config file regardless of its
#            : existence
################################################################################
def getVagrantSSHConfigFilePath(name)
  parent_dir = File.basename(getVagrantFilePath())
  file = File.join(ENV['HOME'], ".ssh/vagrants/#{name}.#{parent_dir}.config")
  return file
end

################################################################################
# Purpose    : Add/update vagrant ssh-config file
# Paramaters : name - the name of the vagrant
# Returns    : n/a
################################################################################
def createVagrantSSHConfigFile(name)

  # Create the ~/.ssh/vagrants subdir
  Dir.mkdir(File.join(ENV['HOME'], ".ssh/vagrants")) unless Dir.exist?(File.join(ENV['HOME'], ".ssh/vagrants"))

  # Create the ssh config file
  out = `vagrant ssh-config #{name}`
  vagrant_ssh_file_path = getVagrantSSHConfigFilePath(name)
  File.open(vagrant_ssh_file_path, 'w') { |f| f.write(out) }

  # Adjust the Host name in the new config file to minimize duplicate names
  parent_dir = File.basename(getVagrantFilePath())
  lines = File.readlines(vagrant_ssh_file_path)
  lines[0] = "Host #{name}.#{parent_dir}" << $/
  File.open(vagrant_ssh_file_path, 'w') { |f| f.write(lines.join) }

  # Add Include line to ~/.ssh/config file if it doesn't exist already
  ssh_config_file_path = getSSHConfigFilePath()
  lines = File.readlines(ssh_config_file_path, chomp: true)
  if lines[0] != "Include ~/.ssh/vagrants/*"
    lines = File.readlines(ssh_config_file_path)
    f = File.open(ssh_config_file_path + ".tmp", 'w')
    f.write("Include ~/.ssh/vagrants/*\n\n")
    f.write(lines.join)
    f.close
    FileUtils.mv(ssh_config_file_path + ".tmp", ssh_config_file_path)
  end
end

################################################################################
# Purpose    : Delete vagrant ssh-config file
# Paramaters : name - the name of the vagrant
# Returns    : n/a
################################################################################
def deleteVagrantSSHConfigFile(name)
  file = getVagrantSSHConfigFilePath(name)
  File.delete(file) if File.exist?(file)
end

################################################################################
# Check for arguments
################################################################################
$arg_destroy = false
$arg_force = false
$arg_up = false
for i in 0 ... ARGV.length
  if "#{ARGV[i]}" == "destroy"
    arg_destroy = true
  end
  if "#{ARGV[i]}" == "-f"
    arg_force = true
  end
  if "#{ARGV[i]}" == "up"
    arg_up = true
  end
end

################################################################################
# If performing 'up' on Windows warn about running 'As Administrator'
################################################################################
if arg_up
  if Vagrant::Util::Platform.windows? then
    def running_in_admin_mode?
      (`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil?
    end

    unless running_in_admin_mode?
      puts "WARNING: To make use of symlinks to the host, Administrative "
      puts "         privileges are required (to execute mklink.exe)."
      puts "         Try again from an Administrative command prompt.\n\n"
    end
  end
end

################################################################################
# Get the path to Vagrantfile
################################################################################
vagrantFilePath = getVagrantFilePath
#puts "vagrantFilePath returned: #{vagrantFilePath}"


# Refrence: https://github.com/martinandersson/dev-mini/blob/master/Vagrantfile

VMCONFIGURATION = {
  name: 'ubuntu22',
  box: 'ubuntu/jammy64',
}, {
  name: 'ubuntu20',
  box: 'ubuntu/focal64',
}, {
  name: 'ubuntu18',
  box: 'ubuntu/bionic64',
}, {
  name: 'ubuntu16',
  box: 'ubuntu/xenial64',
}, {
  name: 'debian10',
  box: 'generic/debian10',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
}, {
  name: 'debian11',
  box: 'generic/debian11',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
},{
  name: 'debian12',
  box: 'generic/debian12',
  mounts: [
    { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
  ]
}, {
    name: 'centos8s',
    box: 'generic/centos8s',
    mounts: [
      { hostPath: ".", guestPath: "/vagrant", type: "virtualbox" }
    ]
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
# Load user configuration
################################################################################
USER_CONFIG = load_user_config

################################################################################
# Configure Vagrant
################################################################################
Vagrant.configure("2") do |config|

  # Conditionally require plugins based on provider
  provider = get_active_provider
  if provider == "virtualbox"
    config.vagrant.plugins = [
      "vagrant-disksize",
      "vagrant-reload"
    ]
  else
    config.vagrant.plugins = [
      "vagrant-reload"
    ]
  end

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

      # Configure disk size based on provider
      disksize = get_vm_config(vmconfig[:name], 'disksize', '40GB')
      configure_disk_size(config, vmconfig[:name], disksize)

      config.vm.boot_timeout = get_vm_config(vmconfig[:name], 'boot_timeout', 300)
      # VirtualBox provider configuration
      config.vm.provider "virtualbox" do |vb|
        vb.cpus = get_vm_config(vmconfig[:name], 'cpus', 1)
        if get_vm_config(vmconfig[:name], 'disable_audio', true)
          # Disable audio card to avoid interference with host audio
          vb.customize ["modifyvm", :id, "--audio", "none"]
        end
        if get_vm_config(vmconfig[:name], 'enable_clipboard', false)
          # Enable bidirectional Clipboard
          vb.customize ["modifyvm", :id, "--clipboard",   "bidirectional"]
        end
        if get_vm_config(vmconfig[:name], 'enable_draganddrop', false)
          # Enable bidirectional file drag and drop
          vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
        end
        vb.gui = get_vm_config(vmconfig[:name], 'gui', false)
        vb.memory = get_vm_config(vmconfig[:name], 'memory', 1024).to_s
        vb.customize ["modifyvm", :id, "--vram", get_vm_config(vmconfig[:name], 'videomemory', 16).to_s]
      end

      # Hyper-V provider configuration
      config.vm.provider "hyperv" do |hv|
        hv.cpus = get_vm_config(vmconfig[:name], 'cpus', 1)
        hv.memory = get_vm_config(vmconfig[:name], 'memory', 1024)
        hv.maxmemory = get_vm_config(vmconfig[:name], 'maxmemory', nil)
        hv.linked_clone = get_vm_config(vmconfig[:name], 'linked_clone', false)
        hv.vmname = "#{vmconfig[:name]}-#{Time.now.to_i}"
      end

      # Configure synced folders based on provider and mount configuration
      unless vmconfig[:mounts].nil?
        vmconfig[:mounts].each do |mount|
          case get_active_provider
          when "virtualbox"
            config.vm.synced_folder mount[:hostPath], mount[:guestPath], type: mount[:type]
          when "hyperv"
            # Hyper-V uses SMB for synced folders
            config.vm.synced_folder mount[:hostPath], mount[:guestPath], type: "smb"
          else
            # Default synced folder (rsync or native)
            config.vm.synced_folder mount[:hostPath], mount[:guestPath]
          end
        end
      else
        # Default synced folder for all VMs if no custom mounts specified
        case get_active_provider
        when "hyperv"
          config.vm.synced_folder ".", "/vagrant", type: "smb"
        else
          # VirtualBox and others use default behavior
        end
      end

      config.vm.provision "ansible_local" do |ansible|
        # ansible.verbose = "vvvv"
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

      config.trigger.after :up do |trigger|
        trigger.on_error = :continue
        trigger.warn = "Adding vagrant to ~/.ssh/config on host"
        trigger.ruby do
          createVagrantSSHConfigFile("#{vmconfig[:name]}")
        end
      end

      config.trigger.after :destroy do |trigger|
        # trigger.on_error = (arg_destroy & arg_force) ? :continue : :halt
        trigger.warn = "Removing vagrant from ~/.ssh/config on host"
        trigger.ruby do
          deleteVagrantSSHConfigFile("#{vmconfig[:name]}")
        end
      end

      config.vm.post_up_message = "VM is ready. You can access by typing 'vagrant ssh #{vmconfig[:name]}'."
    end
  end

  ##############################################################################
  # Win10
  ##############################################################################
  config.vm.define "win10", autostart: false do |win10|
    win10.vm.box = "gusztavvargadr/windows-10"
    win10.vm.guest = :windows
    win10.vm.network :forwarded_port, guest: 5985, host: 5985, host_ip: "127.0.0.1", id: "winrm", auto_correct: true
    win10.vm.network :forwarded_port, host: 33389, guest: 3389, host_ip: "127.0.0.1", id: "rdp", auto_correct: true
    win10.vm.hostname = "win10"

    # Configure disk size based on provider
    disksize = get_vm_config('win10', 'disksize', '60GB')
    configure_disk_size(win10, 'win10', disksize)

    win10.vm.boot_timeout = get_vm_config('win10', 'boot_timeout', 500)
    # VirtualBox provider configuration for Windows 10
    win10.vm.provider "virtualbox" do |vb|
      vb.cpus = get_vm_config('win10', 'cpus', 2)
      if get_vm_config('win10', 'disable_audio', true)
        # Disable audio card to avoid interference with host audio
        vb.customize ["modifyvm", :id, "--audio", "none"]
      end
      if get_vm_config('win10', 'enable_clipboard', false)
        # Enable bidirectional Clipboard
        vb.customize ["modifyvm", :id, "--clipboard",   "bidirectional"]
      end
      if get_vm_config('win10', 'enable_draganddrop', false)
        # Enable bidirectional file drag and drop
        vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      end
      vb.gui = get_vm_config('win10', 'gui', false)
      vb.memory = get_vm_config('win10', 'memory', 2048).to_s
      vb.customize ["modifyvm", :id, "--vram", get_vm_config('win10', 'videomemory', 256).to_s]
    end

    # Hyper-V provider configuration for Windows 10
    win10.vm.provider "hyperv" do |hv|
      hv.cpus = get_vm_config('win10', 'cpus', 2)
      hv.memory = get_vm_config('win10', 'memory', 2048)
      hv.maxmemory = get_vm_config('win10', 'maxmemory', nil)
      hv.linked_clone = get_vm_config('win10', 'linked_clone', false)
      hv.vmname = "win10-#{Time.now.to_i}"
    end

    # Use Windows Remote Management instead of default SSH connections
    win10.vm.communicator = "winrm"
    # gusztavvargadr/windows-10 uses standard vagrant credentials
    win10.winrm.username = "vagrant"
    win10.winrm.password = "vagrant"

    win10.vm.provision "shell", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd 0
    SHELL
    win10.vm.provision "shell", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\provision_win10.cmd
    SHELL

    win10.vm.provision "extendfs", type: "shell", run: "never", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd 0
    SHELL

    win10.vm.post_up_message = "VM is ready. You can access by typing 'vagrant powershell win10' or 'vagrant rdp win10' and using username 'vagrant' and password 'vagrant'."
  end

  ##############################################################################
  # Win11
  ##############################################################################
  config.vm.define "win11", autostart: false do |win11|
    win11.vm.box = "gusztavvargadr/windows-11"
    win11.vm.guest = :windows
    win11.vm.hostname = "win11"

    # Configure disk size based on provider
    disksize = get_vm_config('win11', 'disksize', '127GB')
    configure_disk_size(win11, 'win11', disksize)

    win11.vm.boot_timeout = get_vm_config('win11', 'boot_timeout', 600)
    # VirtualBox provider configuration for Windows 11
    win11.vm.provider "virtualbox" do |vb|
      vb.cpus = get_vm_config('win11', 'cpus', 2)
      if get_vm_config('win11', 'disable_audio', true)
        # Disable audio card to avoid interference with host audio
        vb.customize ["modifyvm", :id, "--audio", "none"]
      end
      if get_vm_config('win11', 'enable_clipboard', false)
        # Enable bidirectional Clipboard
        vb.customize ["modifyvm", :id, "--clipboard",   "bidirectional"]
      end
      if get_vm_config('win11', 'enable_draganddrop', false)
        # Enable bidirectional file drag and drop
        vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      end
      vb.gui = get_vm_config('win11', 'gui', false)
      vb.memory = get_vm_config('win11', 'memory', 4096).to_s
      vb.customize ["modifyvm", :id, "--vram", get_vm_config('win11', 'videomemory', 256).to_s]
    end

    # Hyper-V provider configuration for Windows 11
    win11.vm.provider "hyperv" do |hv|
      hv.cpus = get_vm_config('win11', 'cpus', 2)
      hv.memory = get_vm_config('win11', 'memory', 4096)
      hv.maxmemory = get_vm_config('win11', 'maxmemory', nil)
      hv.linked_clone = get_vm_config('win11', 'linked_clone', false)
      hv.vmname = "win11-#{Time.now.to_i}"
    end

    win11.vm.provision "shell", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd 0
    SHELL
    # win11.vm.provision "shell", privileged: true, inline: <<-SHELL
    #   # $env:DEBUG=1
    #   cmd.exe /c \\vagrant\\scripts\\provision_win11.cmd
    # SHELL

    win11.vm.provision "extendfs", type: "shell", run: "never", privileged: true, inline: <<-SHELL
      # $env:DEBUG=1
      cmd.exe /c \\vagrant\\scripts\\extend_winfs.cmd 0
    SHELL

    win11.vm.post_up_message = "VM is ready. You can access by typing 'vagrant powershell win11' or 'vagrant rdp win11'."
  end
end
