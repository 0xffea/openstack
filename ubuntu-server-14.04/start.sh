
apt-get --yes install software-properties-common
add-apt-repository --yes cloud-archive:liberty
apt-get --yes update
apt-get --yes dist-upgrade

apt-get --yes install python-openstackclient

#
# HOSTNAMES
#

echo "127.0.0.1 controller" >> /etc/hosts

sh install_sql.sh
sh install_keystone.sh
