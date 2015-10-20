#!/usr/bin/env bash

#cp /vagrant/hosts /etc/hosts
#cp /vagrant/resolv.conf /etc/resolv.conf
cp /vagrant/RPM-GPG-KEY-puppetlabs /etc/pki/rpm-gpg
yum install ntp -y
yum install puppet -y
yum install puppet-server -y
service ntpd start
service iptables stop
mkdir -p /root/.ssh; chmod 600 /root/.ssh; cp /home/vagrant/.ssh/authorized_keys /root/.ssh/
# Adding eyaml support for encryption 
gem install hiera-eyaml --no-rdoc --no-ri
#Again, stopping iptables
/etc/init.d/iptables stop

# Increasing swap space
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab

sudo cp /vagrant/insecure_private_key /root/ec2-keypair
sudo chmod 600 /root/ec2-keypair 
