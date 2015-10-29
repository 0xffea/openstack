#
# IMAGE SERVICE
#
mysql -uroot -popenstack <<EOL
CREATE DATABASE glance;

GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
	  IDENTIFIED BY 'openstack';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
	  IDENTIFIED BY 'openstack';
EOL

source admin-openrc.sh

openstack user create --domain default --password openstack glance
openstack role add --project service --user glance admin

openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

apt-get --yes install glance python-glanceclient
# Else a module import error will show up in glance-api.log
apt-get --yes install python-swiftclient

su -s /bin/sh -c "glance-manage db_sync" glance

service glance-registry restart
service glance-api restart

rm -f /var/lib/glance/glance.sqlite
