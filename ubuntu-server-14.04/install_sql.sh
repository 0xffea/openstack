#
# SQL DATABASE
#
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password openstack'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password openstack'
apt-get --yes install mariadb-server python-pymysql
cp config/mysqld_openstack.cnf /etc/mysql/conf.d/
service mysql restart
