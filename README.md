# keedio-vagrant

## Introduction
This is a Vagrant based test environment, designed to test the integration of the different packages of the Keedio software stack, which can be used to deploy virtual clusters using either Ambari or by manually configuring the services.
A hiera based configuration file can be used to adapt Keedio-vagrant to different environments and requirements. 
By default it uses the Keedio public repository to install the packages. To limit the external bandwidth requirement, a local mirror of the main keedio repository repo.keedio.org can be created in a VM called buildoop. The same VM contains the buildoop packaging system and can be used to build new versions of the software components. These new versions can then be deployed to the test VMs using the local repo.
The vagrant plugin "vagrant-vbox-snapshot" can be used to snapshot the state of the cluster, and move easily back and forward in time by selecting the right snapshot.


# Keedio-vagrant with Virtualbox

##Preliminary steps

Install Vagrant and Virtualbox before starting.  
Make sure you install the vagrant snapshotting plugin for virtualbox 
```
vagrant plugin install vagrant-vbox-snapshot
```


Download the keedio-vagrant stack

```
git clone --recursive https://github.com/keedio/keedio-vagrant.git
cd  keedio-vagrant
```

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
##Optional: create local repositories
Start the buildoop VM
```
vagrant up buildoop
```

Enter in the VM, become root and replicate the yum repos
```
vagrant ssh buildoop
sudo su
python /vagrant/sync-localrepo.py
```

Answer "Yes" to all the repositories that you want to replicate. At the moment keedio-1.2, keedio-1.2-updates, and keedio-1.2-develop are supported. This will take several minutes. 
When the process is complete you can check the status of your repo by pointing your browser to http://buildoop/openbus/

### Optional: Installing third party proprietary libraries

```
/vagrant/opsec-setup.sh
```
 
Exit from the buildoop VM
```
exit
```
Modify the hiera/configuration.yaml file to use the local repositories

```
repo_address: 'local'
```

##Start the cluster
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



