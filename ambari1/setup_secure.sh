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

echo "Creating Hiera encryption keys" 
eyaml createkeys

echo "Please provide the activation key:" 
read -s key
string=`eyaml encrypt -s $key -o string`
echo "activation_key:" $string > ./hiera/secure.eyaml


echo "Please provide the admin password for the backend database:[adminadmin]"
read -s key
key="${key:=adminadmin}"
string=`eyaml encrypt -s $key -o string`
echo "db_password:" $string >> ./hiera/secure.eyaml


echo "Please provide the hue user password for the backend database:[hue]"
read -s key
key="${key:=hue}"
string=`eyaml encrypt -s $key -o string`
echo "hue_db_password:" $string >> ./hiera/secure.eyaml


echo "Please provide the hive user password for the backend database:[hive]"
read -s key
key="${key:=hive}"
string=`eyaml encrypt -s $key -o string`
echo "hive_db_password:" $string >> ./hiera/secure.eyaml

echo "Please provide the oozie user password for the backend database:[oozie]"
read -s key
key="${key:=oozie}"
string=`eyaml encrypt -s $key -o string`
echo "oozie_db_password:" $string >> ./hiera/secure.eyaml

echo "Please provide the ambari user password for the backend database:[bigdata]"
read -s key
key="${key:=bigdata}"
string=`eyaml encrypt -s $key -o string`
echo "ambari_db_password:" $string >> ./hiera/secure.eyaml

echo "Please provide the Free IPA admin password:[adminadmin]"
read -s key
key="${key:=adminadmin}"
string=`eyaml encrypt -s $key -o string`
echo "ipa_password:" $string >> ./hiera/secure.eyaml

echo "Please provide the Ambari admin password:[admin]"
read -s key
key="${key:=admin}"
string=`eyaml encrypt -s $key -o string`
echo "ambari_password:" $string >> ./hiera/secure.eyaml




echo "####################################################"
echo "The hiera/secure.eyaml file has been created"
echo "You can check the values and modify it with the command"
echo " "
echo "eyaml edit hiera/secure.eyaml"
echo "#####################################################"

echo "Making a backup-copy of the existing ssh keys in ./files/ssh-backup"
cp -r ./files/.ssh/ ./files/ssh-backup

echo "Generating new ssh keys in ./files/.ssh/"
ssh-keygen -t rsa -f ./files/.ssh/id_rsa -N ""
cat ./files/.ssh/id_rsa.pub >./files/.ssh/authorized_keys
