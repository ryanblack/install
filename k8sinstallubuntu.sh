#!/bin/bash

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

sed -i '/EnvironmentFile=/a Environment=”cgroup-driver=systemd/cgroup-driver=cgroupfs”' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl start kubelet
systemctl enable kubelet

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

