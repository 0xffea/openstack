
apt-get --yes install software-properties-common
add-apt-repository --yes cloud-archive:liberty
apt-get --yes update
apt-get --yes dist-upgrade

apt-get --yes install python-openstackclient

#
# MQ
#
apt-get --yes install rabbitmq-server
rabbitmqctl add_user openstack openstack
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

#
# DOCKER
#
apt-get --yes install docker.io python-pip

#
# HOSTNAMES
#

echo "127.0.0.1 controller" >> /etc/hosts

sh install_sql.sh
sh install_keystone.sh
#sh install_glance.sh
#sh install_compute.sh
#sh install_dashboard.sh
