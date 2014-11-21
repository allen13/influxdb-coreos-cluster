influxdb-coreos-cluster
=======================

An influxdb cluster managed by coreos

####Setup

Requires [Vagrant](https://docs.vagrantup.com/v2/installation/), [Ansible](http://docs.ansible.com/intro_installation.html), and the [fleet binary](https://github.com/coreos/fleet/releases)
    
Install ansible on Ubuntu

    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get update
    $ sudo apt-get install ansible
    
####Running

    vagrant up
    bin/export_vagrant_ssh_keys
    bin/set_fleet_tunnel
    cd units
    ./deploy_influxdb_nodes
    
You can then use fleetctl to mange and monitor your cluster.

####Destroying

When spinning down the cluster it is important to remove the coreos discovery_token so that the cluster will sync itself on the next boot. I added a convienient script to take care of this.

    ./destroy_cluster
    

