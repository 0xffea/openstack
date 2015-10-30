#
# NEUTRON
#

mysql -uroot -popenstack <<EOL
CREATE DATABASE neutron;

GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
	  IDENTIFIED BY 'openstack';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
	  IDENTIFIED BY 'openstack';
EOL

. ./admin-openrc.sh

openstack user create --domain default --password openstack neutron
openstack role add --project service --user neutron admin


openstack service create --name neutron \
	  --description "OpenStack Networking" network

openstack endpoint create --region RegionOne \
	  network public http://controller:9696
openstack endpoint create --region RegionOne \
	  network internal http://controller:9696
openstack endpoint create --region RegionOne \
	  network admin http://controller:9696

apt-get install neutron-server neutron-plugin-ml2 \
	neutron-plugin-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
	neutron-metadata-agent python-neutronclient
