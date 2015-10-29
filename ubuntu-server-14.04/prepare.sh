kvm -m 1024 -smp 4 -cdrom ubuntu-14.04.3-server-amd64.iso -hda openstack.img -netdev user,id=user.0,hostfwd=tcp::2222-:22 -device e1000,netdev=user.0
