wget http://releases.ubuntu.com/14.04.3/ubuntu-14.04.3-server-amd64.iso

qemu-image create -f qcow2 openstack.img 10G

kvm -m 1024 -smp 4 -cdrom ubuntu-14.04.3-server-amd64.iso -hda openstack.img -netdev user,id=user.0,hostfwd=tcp::2222-:22 -device e1000,netdev=user.0

