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

echo "Turn Off SElinux"
setenforce 0 
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "Setting up Firewall"
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp 
firewall-cmd --permanent --add-port=10255/tcp 
firewall-cmd --permanent --add-port=30000-32767/tcp 
firewall-cmd --permanent --add-port=6783/tcp 
firewall-cmd --reload 
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

read -p "Now we need to Reboot..."
shutdown -r now
