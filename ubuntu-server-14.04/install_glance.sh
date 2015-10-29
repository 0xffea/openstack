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

sh admin-openrc.sh

openstack user create --domain default --password openstack glance
openstack role add --project service --user glance admin

openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

apt-get --yes install glance python-glanceclient
# Else a module import error will show up in glance-api.log
apt-get --yes install python-swiftclient

cp config/glance-api.conf /etc/glance/
cp config/glance-registry.conf /etc/glance/

su -s /bin/sh -c "glance-manage db_sync" glance

service glance-registry restart
service glance-api restart

rm -f /var/lib/glance/glance.sqlite

wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
glance image-create --name "cirros" \
	--file cirros-0.3.4-x86_64-disk.img \
	--disk-format qcow2 --container-format bare \
	--visibility public --progress

