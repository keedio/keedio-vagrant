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
block=`eyaml encrypt -s $key -o block`
echo "activation_key: >" > ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the admin password for the backend database:[adminadmin]"
read -s key
key="${key:=adminadmin}"
block=`eyaml encrypt -s $key -o block`
echo "db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the hue user password for the backend database:[hue]"
read -s key
key="${key:=hue}"
block=`eyaml encrypt -s $key -o block`
echo "hue_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the hive user password for the backend database:[hive]"
read -s key
key="${key:=hive}"
block=`eyaml encrypt -s $key -o block`
echo "hive_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the oozie user password for the backend database:[oozie]"
read -s key
key="${key:=oozie}"
block=`eyaml encrypt -s $key -o block`
echo "oozie_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the ambari user password for the backend database:[bigdata]"
read -s key
key="${key:=bigdata}"
block=`eyaml encrypt -s $key -o block`
echo "ambari_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the Free IPA admin password:[adminadmin]"
read -s key
key="${key:=adminadmin}"
block=`eyaml encrypt -s $key -o block`
echo "ipa_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

echo "Please provide the Ambari admin password:[admin]"
read -s key
key="${key:=admin}"
block=`eyaml encrypt -s $key -o block`
echo "ambari_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml




echo "####################################################"
echo "The hiera/secure.eyaml file has been created"
echo "You can check the values and modify it with the command"
echo " "
echo "eyaml edit hiera/secure.eyaml"
echo "#####################################################"
