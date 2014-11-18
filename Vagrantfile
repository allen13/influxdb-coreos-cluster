require 'fileutils'
require 'open-uri'

def discovery_token
  unless File.exist?('discovery_token')
    File.write('discovery_token',open('https://discovery.etcd.io/new').read)
  end
  File.read('discovery_token')
end

def provision_coreos_influxdb_vm(vm_number, config)
  vm_name = "influxdb-%02d" % vm_number
  config.vm.define vm_name do |config|
    config.vm.hostname = vm_name

    config.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.memory = 1024
      vb.cpus = 1
    end

    config.vm.network :private_network, ip: "172.17.8.#{vm_number+100}"

    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "coreos-playbook/bootstrap-coreos.yml"
      ansible.extra_vars = {
        discovery_token: discovery_token,
        ansible_ssh_user: 'core',
        ansible_python_interpreter: "PATH=/home/core/bin:$PATH python"
      }
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "coreos-alpha"
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"

  (1..3).each do |vm_number|
    provision_coreos_influxdb_vm(vm_number, config)
  end
end
