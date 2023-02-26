# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_name = 'iiqbox'

Vagrant.configure("2") do |config|

   # Ensure virtualbox guest plugins are installed and latest
   config.vagrant.plugins = ["vagrant-vbguest"]

   # Name of the vm
   config.vm.define vm_name
   config.vm.hostname = vm_name
   config.vm.box = "generic/centos8"

   # Add port forward for tomcat
   config.vm.network :forwarded_port, guest: 8080, host:8080
   config.vm.network :forwarded_port, guest: 8001, host:8001

   # Port forward for mysql
   config.vm.network :forwarded_port, guest: 3306, host:3306

   # Port forward for ldap
   config.vm.network :forwarded_port, guest: 389, host:10389

   # Private network, fixed ip
   config.vm.network "private_network", ip: "10.0.0.10"

   # CPU and RAM configuration
   config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 4
   end

   # Force Virtualbox sync
   config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

   # VBox Guest options
   config.vbguest.auto_update = true
   config.vbguest.installer_options = { allow_kernel_upgrade: true }
   config.vbguest.installer_hooks[:before_start] = [
      "echo 'vboxsf' > /etc/modules-load.d/vboxsf.conf", 
      "systemctl restart systemd-modules-load.service", 
      "echo '=== Verifying vboxsf module is loaded'", 
      "cat /proc/modules | grep vbox" 
   ]

   # Provision script
   config.vm.provision "setup", type: "shell", path: "setenv.sh", args: "setup.sh", privileged: false, preserve_order: true
end