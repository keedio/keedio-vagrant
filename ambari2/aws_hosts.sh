#!/bin/bash

#This scripts generates a /etc/hosts file with all the internal IP's in AWS. Then you have to make the provision for nodes.
# In the first version, it only take the IP's for AWSKDSMaster and AWSKDSNode[1-5].

location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

aws ec2 describe-instances |grep Value |awk -F"\"" '{printf $4 "\n"}' > /tmp/aws_names
aws ec2 describe-instances |grep -i PrivateDnsName |sed 's/\./-/g' |awk -F"-" '{printf $2"."$3"."$4"."$5 "\n"}' > /tmp/aws_privateip

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > $location/files/aws_hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> $location/files/aws_hosts

i=1
while read line
do
 PIP=`head -"$i" /tmp/aws_privateip | tail -1`
 echo "$PIP $line.kds.local $line" >> $location/files/aws_hosts
 i=$(($i + 1))
done < /tmp/aws_names

rm -f /tmp/aws /tmp/aws2

