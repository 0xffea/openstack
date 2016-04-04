#!/bin/bash
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list
add-apt-repository -y ppa:webupd8team/java
su -c 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
apt-get --yes update
apt-get --yes install oracle-java8-installer
apt-get --yes install mesos marathon chronos curl
mkdir -p /var/lib/mesos
chown ubuntu:ubuntu /var/lib/mesos

service mesos-master start
service marathon start

#
# Install dcos
#
apt-get --yes install python-pip python-virtualenv python-dev
cd /tmp
git clone https://github.com/mesosphere/dcos-cli.git
cd dcos-cli
make env
make packages
cd cli
make env
source bin/env-setup-dev
dcos config set core.mesos_master_url http://localhost:5050

curl -X POST http://localhost:8080/v2/apps -d @marathon.json -H "Content-type: application/json"


#MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
#screen -dmS mesos-master bash -c  "/usr/sbin/mesos-master --ip=$MY_IP --work_dir=/var/lib/mesos"
