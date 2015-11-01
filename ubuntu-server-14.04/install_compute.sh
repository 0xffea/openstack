#
# COMPUTE
#
mysql -uroot -popenstack <<EOL
CREATE DATABASE nova;

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
	                  IDENTIFIED BY 'openstack';
GRANT ALL PRIVILEGES ON nova* TO 'nova'@'%' \
	                  IDENTIFIED BY 'openstack';
EOL

. ./admin-openrc.sh

openstack user create --domain default --password openstack nova
openstack role add --project service --user nova admin

openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2/%\(tenant_id\)s

apt-get --yes install nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler \
	python-novaclient

apt-get --yes install nova-compute sysfsutils

cp config/nova.conf /etc/nova/

su -s /bin/sh -c "nova-manage db sync" nova

service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
service nova-compute restart

rm -f /var/lib/nova/nova.sqlite
