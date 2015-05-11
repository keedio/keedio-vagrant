# keedio-vagrant

## Introduction
This is a Vagrant based test environment, designed to test the integration of the different packages of the Keedio software stack. 
 which can be used to deploy virtual clusters using either Ambari or by manually configuring the services. To limit the external bandwidth requirement, a local mirror of the main keedio repository repo.keedio.org is hosted in a VM called buildoop. The same VM contains the buildoop packaging system and can be used to build new versions of the software components. This new version can then be deployed to the test VMs using the local repo.   



##Preliminary steps

Install Vagrant and Virtualbox before starting. 

For now, make sure you disconnect from the caligula VPN 


Download the keedio-vagrant stack

```
git clone --recursive https://github.com/keedio/keedio-vagrant.git

cd  keedio-vagrant
```

Populate the /etc/hosts of your machine with the provided information
```
cat  append-to-etc-hosts.txt  >> /etc/hosts
```
Start the local repositories 
```
cd buildoop 
vagrant up buildoop
```
Enter in the VM and become root 
```
vagrant ssh buildoop
sudo su
python /vagrant/sync-localrepo.py
```
Answer Yes to all the repositories that you want to replicate. At the moment keedio-1.2 and keedio-1.2-updates. 
This will take several minutes. 
When the process is complete you can check the status of your repo by pointing your browser to http://buildoop/openbus/
 


