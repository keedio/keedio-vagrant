#!/bin/bash

#This script creates a custom /etc/hosts for Azure Vagrant nodes.

location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Get all the IP's internal and public

az vm list-ip-addresses -g "$AZ_RESOURCE_GROUP_NAME" -o table |grep KDS > /tmp/az_hosts

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > $location/files/az_hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> $location/files/az_hosts

cat /tmp/az_hosts |awk -F" " '{print $3 "\t" $1".kds.local""\t" $1}' >> $location/files/az_hosts
cat /tmp/az_hosts |awk -F" " '{print $2 "\t" $1".keedio.local""\t"}' >> $location/ambari1/files/az_hosts

rm -f /tmp/az_hosts
