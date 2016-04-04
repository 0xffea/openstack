#!/bin/bash
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list
apt-get --yes update
apt-get --yes install mesos
echo "$param_mesos_master_ip  mesosmaster" >> /etc/hosts
mkdir -p /var/lib/mesos
chown ubuntu:ubuntu /var/lib/mesos

service mesos-slave start

#MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
#screen -dmS mesos-agent bash -c  "/usr/sbin/mesos-slave --master=mesosmaster:5050 --ip=$MY_IP --work_dir=/var/lib/mesos"
