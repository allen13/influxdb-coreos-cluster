#!/bin/bash
source /etc/environment
hostname=$(cat /etc/hostname)
machines=$(/usr/bin/etcdctl ls /consul.io/bootstrap/machines)

if [ -z "$machines" ]
then
flags="${flags} -bootstrap-expect 3"
else
echo "This cluster has already been bootstrapped"
flags=$(/usr/bin/etcdctl ls /consul.io/bootstrap/machines | while read line; do
        ip=$(/usr/bin/etcdctl get ${line})
        echo ${flags} -join ${ip}
      done)
fi

echo "Flags are:" $flags

/usr/bin/etcdctl set /consul.io/bootstrap/machines/${hostname} ${COREOS_PRIVATE_IPV4}

/usr/bin/docker run --name consul \
      -h ${hostname} \
      -p ${COREOS_PRIVATE_IPV4}:8300:8300 \
      -p ${COREOS_PRIVATE_IPV4}:8301:8301 \
      -p ${COREOS_PRIVATE_IPV4}:8301:8301/udp \
      -p ${COREOS_PRIVATE_IPV4}:8302:8302 \
      -p ${COREOS_PRIVATE_IPV4}:8302:8302/udp \
      -p ${COREOS_PRIVATE_IPV4}:8400:8400 \
      -p ${COREOS_PRIVATE_IPV4}:8500:8500 \
      -p 10.1.42.1:53:53/udp \
      -v /opt/consul/data:/data \
      progrium/consul -server -advertise ${COREOS_PRIVATE_IPV4} ${flags}
