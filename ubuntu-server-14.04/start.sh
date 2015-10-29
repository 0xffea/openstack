
apt-get --yes install software-properties-common
add-apt-repository --yes cloud-archive:liberty
apt-get --yes update
apt-get --yes dist-upgrade

apt-get --yes install python-openstackclient

#
# HOSTNAMES
#

echo -e "127.0.0.1\tcontroller" >> /etc/hosts

sh install_sql.sh
sh install_keystone.sh
