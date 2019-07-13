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

read -p "Now we need to Reboot..."
shutdown -r now
