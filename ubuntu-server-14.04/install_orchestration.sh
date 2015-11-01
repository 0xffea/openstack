#
# HEAT
#

mysql -uroot -popenstack <<EOL
CREATE DATABASE heat;

GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' \
	  IDENTIFIED BY 'openstack';
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' \
	  IDENTIFIED BY 'openstack';
EOL

. /admin-openrc.sh

openstack user create --domain default --password openstack heat
openstack role add --project service --user heat admin

openstack service create --name heat --description "Orchestration" orchestration 
openstack service create --name heat-cfn --description "Orchestration"  cloudformation

openstack endpoint create --region RegionOne \
	  orchestration public http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
	  orchestration internal http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
	  orchestration admin http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
	  cloudformation public http://controller:8000/v1
openstack endpoint create --region RegionOne \
	   cloudformation internal http://controller:8000/v1
openstack endpoint create --region RegionOne \
	   cloudformation admin http://controller:8000/v1

openstack domain create --description "Stack projects and users" heat
openstack user create --domain heat --password openstack heat_domain_admin
openstack role add --domain heat --user heat_domain_admin admin

openstack role create heat_stack_owner
openstack role add --project demo --user demo heat_stack_owner
openstack role create heat_stack_user

apt-get --yes install heat-api heat-api-cfn heat-engine \
	  python-heatclient



