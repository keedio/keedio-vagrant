#!/bin/bash 

echo "####################################################"
echo "Setting up environment for Keedio Stack deployment" 
echo "This will use default encryption keys and passwords" 
echo "Please use setup_secure.sh if you want to change them" 
echo "#####################################################"
eyaml version
if [  $?  -ne 0 ] 
then 
echo "hiera-eyaml is not installed on this system, please install it with"
echo "#sudo gem install hiera-eyaml"
exit
fi
if [ ! -d "./hiera" ]
then
  echo "Cannot find hiera directory"
  echo "This script must be executed in the directory where the Vagrantfile is, ie ambari1"
  exit
fi

echo "Please provide the activation key:" 
read -s key
block=`eyaml encrypt -s $key -o string`
echo "activation_key:" $block > ./hiera/secure.eyaml


block=`eyaml encrypt -s adminadmin -o string`
echo "db_password:" $block  >> ./hiera/secure.eyaml

block=`eyaml encrypt -s hue -o string`
echo "hue_db_password:" $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s hive -o string`
echo "hive_db_password:" $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s oozie -o string`
echo "oozie_db_password:" $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s bigdata -o string`
echo "ambari_db_password:" $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s adminadmin -o string`
echo "ipa_password:" $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s admin -o string`
echo "ambari_password:" $block >> ./hiera/secure.eyaml






echo "####################################################"
echo "The hiera/secure.eyaml file has been created"
echo "You can check the values and modify it with the command"
echo " "
echo "eyaml edit hiera/secure.eyaml"
echo "#####################################################"
