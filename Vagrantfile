# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "box-cutter/debian77"

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Gotham City Gateways
  (0..4).each do |i|
		config.vm.define "gc-gw#{i}" do |node|
			node.vm.hostname = "gc-gw#{i}"
			node.vm.network "private_network", ip: "172.19.1.#{i+1}", netmask: "255.255.0.0"
			node.vm.provision :shell, path: "bootstrap.sh", args: "gc-gw#{i}"
		end
  end


  # Metropolis
  (0..1).each do |i|
		config.vm.define "mp-gw#{i}" do |node|
			node.vm.hostname = "gc-gw#{i}"
			node.vm.network "private_network", ip: "172.19.2.#{i+1}", netmask: "255.255.0.0"
			node.vm.provision :shell, path: "bootstrap.sh", args: "gc-gw#{i}"
		end
  end
end
