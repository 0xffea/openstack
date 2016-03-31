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
  neutron-metadata-agent python-neutronclient conntrack

cp config/neutron.conf /etc/neutron/
cp config/ml2_conf.ini /etc/neutron/plugins/ml2/
cp config/linuxbridge_agent.ini /etc/neutron/plugins/ml2/
cp config/l3_agent.ini /etc/neutron/
cp config/dhcp_agent.ini /etc/neutron/
cp config/dnsmasq-neutron.conf /etc/neutron/

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
	  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart

service neutron-server restart
service neutron-plugin-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart

service neutron-l3-agent restart

rm -f /var/lib/neutron/neutron.sqlite
