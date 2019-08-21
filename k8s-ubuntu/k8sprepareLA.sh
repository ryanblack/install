#!/bin/bash

#PREPARE for K8s install

echo "Adding K8s Repo"
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
echo "DONE!"

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

echo "Turning Off SElinux"
setenforce 0 
echo "DONE!"

sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "Setting up Firewall"
iptables -I INPUT -p tcp -m tcp --dport 10250 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 10255 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 6783 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 6443 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 2379:2380 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 30000:32767 -j ACCEPT
iptables -L|grep dpt
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
echo "DONE!"

read -p "Now we need to Reboot..."
shutdown -r now
