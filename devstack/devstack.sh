
sudo apt-get --yes install pwgen git wget

ADMIN_PASSWORD=$(pwgen -B 4 1)
sed -i "s/ADMIN_PASSWORD=.*/ADMIN_PASSWORD=$ADMIN_PASSWORD/" local.conf

git config user.email "0xffea@gmail.com"
git config user.name "David Höppner"

git clone https://git.openstack.org/openstack-dev/devstack

chmod a+x local.sh

cd devstack
git checkout 1a2f86b3be1e

ln -s ../local.conf local.conf
ln -s ../local.sh local.sh

./stack.sh
# BUG: has a problem when run by stack.sh
sh ../local.sh
