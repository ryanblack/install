#!/bin/bash
swapoff -a
sed -i.bak '/swap/d' /etc/fstab

read -p "Now we need to Reboot..."
shutdown -r now
