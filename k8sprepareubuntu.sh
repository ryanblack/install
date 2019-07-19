#!/bin/bash

echo "Set syctemd driver in Docker"
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
echo "DONE!"

echo "Docker Restarted"
systemctl restart docker

docker info |grep Cgroup

#Turnoff Swaping
echo "Swaping is Off now..."
swapoff -a
sed -i.bak '/swap/d' /etc/fstab

read -p "Now we need to Reboot..."
shutdown -r now
