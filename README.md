# keedio-vagrant

## Introduction
This is a Vagrant based test environment, designed to test the integration of the different packages of the Keedio software stack, which can be used to deploy virtual clusters using either Ambari or by manually configuring the services. To limit the external bandwidth requirement, a local mirror of the main keedio repository repo.keedio.org is hosted in a VM called buildoop. The same VM contains the buildoop packaging system and can be used to build new versions of the software components. These new versions can then be deployed to the test VMs using the local repo.
The vagrant plugin "vagrant-vbox-snapshot" can be used to snapshot the state of the cluster, and move easily back and forward in time by selecting the right snapshot.



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
Start the local repositories 
```
cd  ambari1
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

Installing third party proprietary libraries

```
/vagrant/opsec-setup.sh
```
 
Exit from the buildoop VM
```
exit
```

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

# keedio-vagrant on the Cediant openstack cloud 

It's possible to start keedio-vagrant on the Cediant cloud using the openstack-provider plugin. You have to install the plugin first.
```
vagrant plugin install vagrant-openstack-provider
```
At the moment you need to clone the relative branch, enter the ambari1 folder and edit the Vagrant file to specify your credentials 

```
os.username           = 'Your username'
os.password           = 'Your password'
os.tenant_name        = 'Your tenant'
```
After that you can start you VMs with vagrant up adding a flag to specify the openstack provider. Buildoop is not required, as the Cediant cloud local repo will be used.

```
vagrant up master ambari1 ambari2 --provider=openstack
```

This version of openstack doesn't export "metadata" to the guests, so the hostsnames and name resolution is not set. We need to to execute a script to fix it. In the directory ambari1 issue 
```
#python set-hosts-openstack.py

########################################################
KEEDIO-VAGRANT
Automatic population of /etc/hosts for cloud environment
########################################################

Collecting information about available nodes

master                    active (openstack)
ambari1                   active (openstack)
ambari2                   active (openstack)
Available nodes:
['master', 'ambari1', 'ambari2']

setting hostnames on the VMs

...

master
Private IP: 192.168.0.6
Floating IP: 10.129.135.119

ambari1
Private IP: 192.168.0.2
Floating IP: 10.129.135.118

ambari2
Private IP: 192.168.0.3
Floating IP: 10.129.135.167

Add the following lines to your local /etc/hosts

#Cluster ambari /etc/hosts section starts here###
10.129.135.119  master.ambari.keedio.org  master
10.129.135.118  ambari1.ambari.keedio.org  ambari1
10.129.135.167  ambari2.ambari.keedio.org  ambari2
#Cluster ambari /etc/hosts section end here######


!!!Remember to run the following command!!!
 vagrant provision
 ```
It is useful to copy and paste the section 
```
#Cluster ambari /etc/hosts section starts here###
10.129.135.119  master.ambari.keedio.org  master
10.129.135.118  ambari1.ambari.keedio.org  ambari1
10.129.135.167  ambari2.ambari.keedio.org  ambari2
#Cluster ambari /etc/hosts section end here######
```
in the /etc/hosts file of your workstation. Rememebr to remove ti when you destroy the cluster.

This script has now populated a puppet module, so you can now propagate the configuration changes with 
```
vagrant provision
```
You should be able to point your browser to master.ambari.keedio.org:8080 and install your cluster.

Notice: everytime you install a new host in the cluster, you have to repeat the execution of the  script and the vagrant provision steps. The script is cusomizable, and you can select different cluster and domain names for your cluster.  









