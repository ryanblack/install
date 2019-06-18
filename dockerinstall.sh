#!/bin/bash
yum -y install yum-utils lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y update
yum -y install docker-ce
systemctl enable docker && systemctl start docker && systemctl status docker
