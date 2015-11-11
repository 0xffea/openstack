#!/bin/sh
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list
add-apt-repository -y ppa:webupd8team/java
su -c 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
apt-get --yes update
apt-get --yes install oracle-java8-installer
apt-get --yes install mesos marathon chronos
mkdir -p /var/lib/mesos
chown ubuntu:ubuntu /var/lib/mesos
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
screen -d -m /usr/bin/mesos-master --ip=$MY_IP --work_dir=/var/lib/mesos
