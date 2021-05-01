# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_name = 'iiqbox'

Vagrant.configure("2") do |config|

   config.vm.define vm_name
   config.vm.hostname = vm_name
   config.vm.box = "bento/centos-8"

   # Add port forward for tomcat
   config.vm.network :forwarded_port, guest: 8080, host:8080
   config.vm.network :forwarded_port, guest: 8001, host:8001

   # Port forward for mysql
   config.vm.network :forwarded_port, guest: 3306, host:3306

   # Private network, fixed ip
   config.vm.network "private_network", ip: "10.0.0.10"

   config.vbguest.installer_options = { allow_kernel_upgrade: true }

   config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
   end

   config.vm.provision "setup", type: "shell", path: "setupEnv.sh", args: "bootstrap.sh", privileged: false, preserve_order: true
end