#!/bin/bash

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "Insall Kubeadm"
yum -y install kubeadm
systemctl enable kubelet.service
