#!/bin/bash

#This scripts generates a /etc/hosts file with all the internal IP's in AWS. Then you have to make the provision for nodes.
# In the first version, it only take the IP's for AWSKDSMaster and AWSKDSNode[1-5].

aws ec2 describe-instances   --query "Reservations[*].Instances[*].PrivateIpAddress" | grep .\" |sed 's/"/ /g' |sed 's/ //g'> /tmp/aws

AWSKDSMASTER=`head -1 /tmp/aws`

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 \n ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" > ~/git/keedio-vagrant/ambari1/files/aws_hosts

echo "$AWSKDSMASTER awskdsmaster.keedio.local awskdsmaster" >> ~/git/keedio-vagrant/ambari1/files/aws_hosts

sed '1d' /tmp/aws > /tmp/aws2

i=1
while read line
do
 echo "$line awskdsnode$i.keedio.local awskdsnode$i" >> ~/git/keedio-vagrant/ambari1/files/aws_hosts
 i=$(($i + 1))
done < /tmp/aws2

rm -f /tmp/aws /tmp/aws2

