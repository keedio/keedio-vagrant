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
block=`eyaml encrypt -s $key -o block`
echo "activation_key: >" > ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s adminadmin -o block`
echo "db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s hue -o block`
echo "hue_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s hive -o block`
echo "hive_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s oozie -o block`
echo "oozie_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s bigdata -o block`
echo "ambari_db_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s adminadmin -o block`
echo "ipa_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml

block=`eyaml encrypt -s admin -o block`
echo "ambari_password: >" >> ./hiera/secure.eyaml
echo $block >> ./hiera/secure.eyaml





echo "####################################################"
echo "The hiera/secure.eyaml file has been created"
echo "You can check the values and modify it with the command"
echo " "
echo "eyaml edit hiera/secure.eyaml"
echo "#####################################################"
