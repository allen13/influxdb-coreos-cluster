influxdb-coreos-cluster
=======================

An influxdb cluster managed by coreos

This setup is based on these CoreOS guides

  * [Controlling a CoreOS cluster with fleetctl](https://coreos.com/docs/launching-containers/launching/fleet-using-the-client/)
  * [Clustering CoreOS with vagrant](https://coreos.com/blog/coreos-clustering-with-vagrant/)
  * [Vagrant CoreOS](https://coreos.com/docs/running-coreos/platforms/vagrant/)

####Setup

Requires [Vagrant](https://docs.vagrantup.com/v2/installation/), [Ansible](http://docs.ansible.com/intro_installation.html), and [fleetctl](https://github.com/coreos/fleet/)
    
Install ansible on Ubuntu

    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:ansible/ansible
    $ sudo apt-get update
    $ sudo apt-get install ansible
    
Install fleetctl

    wget https://github.com/coreos/fleet/releases/download/v0.8.3/fleet-v0.8.3-linux-amd64.tar.gz -O - | sudo tar -xz -C /opt/
    sudo ln -s /opt/fleet-v0.8.3-linux-amd64/fleetctl /usr/local/bin/fleetctl
    
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
    

