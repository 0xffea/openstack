#!/bin/bash

#
# DOCKER
#
apt-get update
apt-get --yes install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get --yes install linux-image-extra-$(uname -r)
apt-get --yes install apparmor
apt-get --yes install docker-engine
service docker start

exit 1
#
# MESOS CLIENT
#
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list
apt-get --yes update
apt-get --yes install mesos
echo "$param_mesos_master_ip  mesosmaster" >> /etc/hosts
mkdir -p /var/lib/mesos
chown ubuntu:ubuntu /var/lib/mesos

echo 'docker,mesos' > /etc/mesos-slave/containerizers
echo '5mins' > /etc/mesos-slave/executor_registration_timeout

service mesos-slave start

#MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
#screen -dmS mesos-agent bash -c  "/usr/sbin/mesos-slave --master=mesosmaster:5050 --ip=$MY_IP --work_dir=/var/lib/mesos"
