#!/bin/bash

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "Insall Kubeadm"
yum -y install kubeadm
systemctl enable kubelet.service
kubeadm config images pull

echo "Initialize Kubeadm"
kubeadm init

echo "Set some settings"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "Weave Network deploy"
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

echo "Worker Join Command:"
kubeadm token create --print-join-command
