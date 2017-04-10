# keedio-vagrant



## Introduction
This is a Vagrant based test environment, designed to test the integration of the different packages of the Keedio software stack, which can be used to deploy virtual clusters using either Ambari or by manually configuring the services.
A hiera based configuration file can be used to adapt Keedio-vagrant to different environments and requirements. 
By default it uses the Keedio public repository to install the packages. To limit the external bandwidth requirement, a local mirror of the main keedio repository repo.keedio.org can be created in a VM called buildoop. The same VM contains the buildoop packaging system and can be used to build new versions of the software components. These new versions can then be deployed to the test VMs using the local repo.
The vagrant plugin "vagrant-vbox-snapshot" can be used to snapshot the state of the cluster, and move easily back and forward in time by selecting the right snapshot.


## Obtaining access to Keedio stack
Keedio uses Red Hat satellite to manage the distribution of its Keedio stack, in order to install it stack you need to request an activation code.   You can request it here  https://www.keedio.org/demo/

You have to use it in the setup process. 

As an alternative you can package your own repository using buildoop and you can tell keedio-vagrant to use default yum repositories by setting the variable satellite: false in ./hiera/configuration.yaml.


#Preliminary steps

Install Vagrant and Virtualbox before starting.  
Make sure you install the vagrant snapshotting plugin for virtualbox 
```
vagrant plugin install vagrant-vbox-snapshot
```
Install hiera-eyaml ruby gem
```
gem install hiera-eyaml
```
Download the keedio-vagrant stack

```
git clone --recursive https://github.com/keedio/keedio-vagrant.git
cd  keedio-vagrant
```

#Setup the cluster
The following procedure is required and independent from hypervisor or cloud provider.
```
./setup.sh
####################################################
Setting up environment for Keedio Stack deployment
This will use default encryption keys and passwords
Please use setup_secure.sh if you want to change them
#####################################################
[hiera-eyaml-core] hiera-eyaml (core): 2.0.8
Please provide the activation key:
####################################################
The hiera/secure.eyaml file has been created
You can check the values and modify it with the command

eyaml edit hiera/secure.eyaml
#####################################################
```
## Optional: setup the cluster in secure mode

To generate new encryption keys, and set non default password you can issue the foillowing command:
```
./setup_secure.sh

####################################################
Setting up environment for Keedio Stack deployment
This will use default encryption keys and passwords
Please use setup_secure.sh if you want to change them
#####################################################
[hiera-eyaml-core] hiera-eyaml (core): 2.0.8
Creating Hiera encryption keys
Are you sure you want to overwrite "./keys/private_key.pkcs7.pem"? (y/N): y
Are you sure you want to overwrite "./keys/public_key.pkcs7.pem"? (y/N): y
[hiera-eyaml-core] Keys created OK
Please provide the activation key:
Please provide the admin password for the backend database:[adminadmin]
Please provide the hue user password for the backend database:[hue]
Please provide the hive user password for the backend database:[hive]
Please provide the oozie user password for the backend database:[oozie]
Please provide the ambari user password for the backend database:[bigdata]
Please provide the Free IPA admin password:[adminadmin]
Please provide the Ambari admin password:[admin]
####################################################
The hiera/secure.eyaml file has been created
You can check the values and modify it with the command

eyaml edit hiera/secure.eyaml
#####################################################
Making a backup-copy of the existing ssh keys in ./files/ssh-backup
Generating new ssh keys in ./files/.ssh/
Generating public/private rsa key pair.
./files/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Your identification has been saved in ./files/.ssh/id_rsa.
Your public key has been saved in ./files/.ssh/id_rsa.pub.
The key fingerprint is...
```

# Keedio-vagrant with Virtualbox

## Preliminary steps


Populate the /etc/hosts of your machine with the provided information
```
sudo cat  append-to-etc-hosts.txt  >> /etc/hosts
```
Prepare Vagrantfile and configuration.yaml
```
cd  ambari1
cp vagrantfiles/Vagrantfile.virtualbox Vagrantfile
cp configurations/standard-user.yaml hiera/configuration.yaml
```




Start the cluster:
You can now start your ambari cluster, you should always start the master machine, and a number of slaves (ambari1, ambari2, ambari3...)

```
vagrant up master ambari1 ambari2
```

this can take several minutes, when it is complete you should be able to access the Ambari web page: master.ambari.keedio.org:8080. The default credentials are both "admin".

 
You can suspend the execution of all the VMs with
```
vagrant suspend
```

And restart with 

```
vagrant resume
```
# Keedio-vagrant on Azure

## Preliminary steps

For use Azure for deployment you need the following things:

- At least a trial account on Microsoft Azure.
- Install Azure-cli (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Install the Vagrant plugin for Azure

## Installing Azure CLI

You can try install it with the Microsoft install notes for Azure CLI (strongly recommended):

```
curl -L https://aka.ms/InstallAzureCli | bash
```
You must restart the shell:

```
exec -l $SHELL
```

## Configuring Azure CLI

In order to interact with Azure machines, we'll need to do login in our Azure's account. Execute the next command and follow the steps printed on the screen:

```
az login
```

If you want to be sure that it have been logged:

```
az account list
```

## Generating keys for Azure deployments

The Azure provider seems to only like PEM files with both the public and private keys, and X509 certificates, so let’s get us some of that:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/.ssh/azurevagrant.key -out ~/.ssh/azurevagrant.key
chmod 600 ~/.ssh/azurevagrant.key
openssl x509 -inform pem -in ~/.ssh/azurevagrant.key -outform der -out ~/.ssh/azurevagrant.cer
```
The .cer file contains our public key, but the .pem file contains both our public and private keys, so we’ll need to secure it appropriately.
Now we can upload that .cer file as a management certificate in Azure using the browser.

# Know problems

If you delete VMs in horizon, vagrant will enter an invalid state and you will be forced to start from scratch. 

# Optional:  Enabling Free IPA

Free IPA is a RedHat service that provides LDAP and Kerberos authentication, you need to enable it only if you want to test the securization of your cluster. We reccomend enabling it after the VMs have been started. In order to do that you have to change the hiera/configuration.yaml file.
```
ipa: true
```
Then you have to reprovision all the VMs
```
vagrant provision
```

# Managing passwords 

We use hiera-eyaml to encrypt passwords in the file /keedio-vagrant/ambari1/hiera/secure.eyaml. Full descrition of hiera-email can be found here https://github.com/TomPoulton/hiera-eyaml. Here we give a quick introduction. 
To install hiera-eyaml 
```
gem install hiera-eyaml
```
You need to move to ambari1 folder. 

You can view and edit existing passwords with 
```
eyaml edit hiera/secure.eyaml
```
You can create new encryption  keys with 
```
eyaml createkeys
```
You can encrypt passwords with 
```
eyaml encrypt -s 'password'
```
You can take the output and paste it manually into hiera/secure.eyaml using any editor.  









