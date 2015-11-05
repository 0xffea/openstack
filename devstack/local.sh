#!/usr/bin/env bash

# Keep track of the DevStack directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

# Import common functions
source $TOP_DIR/functions

# Use openrc + stackrc + localrc for settings
source $TOP_DIR/stackrc

# Destination path for installation ``DEST``
DEST=${DEST:-/opt/stack}

if is_service_enabled nova; then

	source $TOP_DIR/openrc demo demo

	nova keypair-add heat_key > heat_key.pem
	chmod 600 heat_key.pem

fi

if is_service_enabled neutron; then

	source $TOP_DIR/openrc demo demo

	neutron subnet-update --dns-nameserver 8.8.8.8 private-subnet

	neutron security-group-rule-create --protocol tcp      --port-range-min 22 --port-range-max 22 --direction ingress default
	neutron security-group-rule-create --protocol icmp     --direction ingress --remote-ip-prefix 0.0.0.0/0 default

fi

if is_service_enabled heat; then

	source $TOP_DIR/openrc demo demo

	heat stack-create -u https://raw.githubusercontent.com/0xffea/openstack/master/stacks/hot/hello_world.yaml --tags devstack cirros
fi
