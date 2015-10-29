#
# KEYSTONE
#
mysql -uroot -popenstack <<EOL
CREATE DATABASE keystone;

GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
	          IDENTIFIED BY 'openstack';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
	          IDENTIFIED BY 'openstack';
EOL

echo "manual" > /etc/init/keystone.override

apt-get --yes install keystone apache2 libapache2-mod-wsgi  memcached python-memcache
cp config/keystone.conf /etc/keystone/

su -s /bin/sh -c "keystone-manage db_sync" keystone

echo "ServerName controller" >> /etc/apache2/apache2.conf

cp config/wsgi-keystone.conf /etc/apache2/sites-available/
ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
service apache2 restart
rm -f /var/lib/keystone/keystone.db


export OS_IDENTITY_API_VERSION=3
export OS_URL=http://controller:35357/v3
export OS_TOKEN=123

openstack service create --name keystone --description "OpenStack Identity" identity

openstack endpoint create --region RegionOne identity public http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0

openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default  --password openstack admin
openstack role create admin
openstack role add --project admin --user admin admin

openstack project create --domain default --description "Service Project" service

openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default  --password openstack demo
openstack role create user
openstack role add --project demo --user demo user

