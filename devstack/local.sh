#!/usr/bin/env bash

# Keep track of the DevStack directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

# Import common functions
source $TOP_DIR/functions

# Use openrc + stackrc + localrc for settings
source $TOP_DIR/stackrc

# Destination path for installation ``DEST``
DEST=${DEST:-/opt/stack}

#
# prepare host network
#
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE


if is_service_enabled nova; then

	source $TOP_DIR/openrc demo demo

	nova keypair-add heat_key > heat_key.pem
	chmod 600 heat_key.pem

	source $TOP_DIR/openrc admin admin
	if test ! -e wily-server-cloudimg-amd64-disk1.img; then
		wget https://cloud-images.ubuntu.com/wily/current/wily-server-cloudimg-amd64-disk1.img
	fi
	openstack image create --public --disk-format qcow2 --tag devstack --file wily-server-cloudimg-amd64-disk1.img ubuntu-wily-cloudimg

	if test ! -e trusty-server-cloudimg-amd64-disk1.img; then
		wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
	fi
	openstack image create --public --disk-format qcow2 --tag devstack --file trusty-server-cloudimg-amd64-disk1.img ubuntu-trusty-cloudimg
fi

if is_service_enabled neutron; then

	source $TOP_DIR/openrc demo demo

	neutron subnet-update --dns-nameserver 8.8.8.8 private-subnet

	neutron security-group-rule-create --protocol tcp      --port-range-min 22 --port-range-max 22 --direction ingress default
	neutron security-group-rule-create --protocol icmp     --direction ingress --remote-ip-prefix 0.0.0.0/0 default

fi

if is_service_enabled heat; then

	source $TOP_DIR/openrc demo demo

	heat stack-create --template-file ../../stacks/hot/spark.yaml --tags devstack spark
fi
