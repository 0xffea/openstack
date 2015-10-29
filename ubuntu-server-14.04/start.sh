
apt-get --yes install software-properties-common
add-apt-repository --yes cloud-archive:liberty
apt-get --yes update
apt-get --yes dist-upgrade

apt-get --yes install python-openstackclient

#
# HOSTNAMES
#

echo -e "127.0.0.1\tcontroller" >> /etc/hosts

#
# SQL DATABASE
#
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password openstack'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password openstack'
apt-get --yes install mariadb-server python-pymysql
cp config/mysqld_openstack.cnf /etc/mysql/conf.d/
service mysql restart

