#
# SQL DATABASE
#
debconf-set-selections <<EOL
mysql-server mysql-server/root_password password openstack
EOL

debconf-set-selections <<EOL
mysql-server mysql-server/root_password_again password openstack
EOL

apt-get --yes install mariadb-server python-pymysql
cp config/mysqld_openstack.cnf /etc/mysql/conf.d/
service mysql restart
