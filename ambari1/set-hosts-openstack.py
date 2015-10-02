#!/bin/env python

import os
import subprocess 
import sys

#Configuration 

number_of_slaves=9
DEBUG=True

#Extracting domain information from hiera confs

cmd= subprocess.Popen("grep  'set_subdomain' hiera/configuration.yaml| awk '{ print $2}'",shell=True,stdout=subprocess.PIPE)
cluster_name, err=cmd.communicate()
cluster_name=cluster_name.replace('\n','')
cluster_name=cluster_name.replace('\'','')
cluster_name=cluster_name.replace(' ','')
cmd= subprocess.Popen("grep  'set_domain' hiera/configuration.yaml| awk '{ print $2}'",shell=True,stdout=subprocess.PIPE)
domain_name, err=cmd.communicate()
domain_name=domain_name.replace('\n','')
domain_name=domain_name.replace('\'','')
domain_name=domain_name.replace(' ','')

print cluster_name,domain_name,'aa'
if not cluster_name or not domain_name:
     print "Domain information not found in configuration.yaml, reverting to default"
     cmd= subprocess.Popen("grep  'set_subdomain' hiera/default.yaml| awk '{ print $2}'",shell=True,stdout=subprocess.PIPE)
     cluster_name, err=cmd.communicate()
     cluster_name=cluster_name.replace('\n','')
     cluster_name=cluster_name.replace('\'','')
     cluster_name=cluster_name.replace('\ ','')
     cmd= subprocess.Popen("grep  'set_domain' hiera/default.yaml| awk '{ print $2}'",shell=True,stdout=subprocess.PIPE)
     domain_name, err=cmd.communicate()
     domain_name=domain_name.replace('\n','')
     domain_name=domain_name.replace('\'','')
     domain_name=domain_name.replace('\ ','')


if not cluster_name or not domain_name:
     print "No default configuration found for domain information, you have to run this program in the same dir of the Vagrantfile"
     exit()
   

#Process 
print "########################################################"
print "KEEDIO-VAGRANT"
print "Automatic population of /etc/hosts for cloud environment"
print "########################################################\n"


try:
    file=open("manifests/modules/host-manager/manifests/init.pp","w") 
except:
    print"Error openin manifest, you must be in the same directory of the Vagrantfile"
    exit() 


print "Collecting information about available nodes\n"


Nodes=['master','buildoop']
FQDN={'master':'master.'+cluster_name+"."+domain_name,'buildoop':'buildoop.'+cluster_name+"."+domain_name};

for n in range(1,number_of_slaves+1):
	Nodes.append("ambari"+str(n))
        FQDN["ambari"+str(n)]="ambari"+str(n)+"."+cluster_name+"."+domain_name

if DEBUG:
 	print FQDN

available_nodes=[] 
for node in Nodes:
    cmd=subprocess.call("vagrant status "+str(node)+"| grep active",shell=True)
    if cmd == 0:
       available_nodes.append(node) 

print "Available nodes:"
print  available_nodes
dict_values={}

print "\n","setting hostnames on the VMs\n" 

for node in available_nodes:
    command="vagrant ssh -c 'sudo hostname "+FQDN[node]+"' "+str(node)
    if DEBUG:
        print command
    cmd= subprocess.Popen(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    out, err = cmd.communicate()
    if DEBUG:
        print "Setting in memory hostname for", node 
        print out 
        print err 

    command= 'printf \'HOSTNAME='+str(FQDN[node])+'\\nNETWORKING=yes\\nNISDOMAIN='+cluster_name+'.'+domain_name+"\\n\' | sudo tee /etc/sysconfig/network"
    command='vagrant ssh -c "'+command+'" '+str(node)
    if DEBUG:
        print command 
    cmd= subprocess.Popen(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    out, err = cmd.communicate()
    if DEBUG:
        print "Setting permanent hostname for", node
        print out
        print err   

    if not DEBUG:
        sys.stdout.write('.')
        sys.stdout.flush()
print "\n"

for node in available_nodes:
    process=subprocess.Popen('vagrant ssh -c "ifconfig eth0 | grep inet\ addr|cut -d \':\' -f 2 | cut -d \' \' -f 1" '+str(node),shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    out, err = process.communicate()
    if DEBUG:
        print "Getting IP information for", node
        print out
        print err
    err=err.replace('Connection to','')
    err=err.replace('closed.','')
    print node
    print "Private IP:",out.strip()
    print "Floating IP:",err.strip(),"\n"
    dict_values[str(node)]=[FQDN[str(node)],out.strip(),err.strip()]

if DEBUG:
    print "Dictionary of node information"
    print dict_values

try:
    file.write("class  host-manager  {\n")
    for node in available_nodes:
        fileline="file_line{\'"+node+"_line\':\n           path => \'/etc/hosts\',\n           line => \'"+dict_values[node][1]+"  "+dict_values[node][0]+"  "+ str(node)+"\',\n        notify  => Service['ambari-agent'],\n          ensure => \'present\',\n          }\n"
        file.write(fileline)

    file.write("}")
except:
    print "Fatal: Error in writing the puppet manifest"
    exit()

print "Add the following lines to your local /etc/hosts\n"

print "#Cluster "+cluster_name+" /etc/hosts section starts here###"
for node in available_nodes:
     print dict_values[node][2]+"  "+dict_values[node][0]+"  "+ str(node)
print "#Cluster "+cluster_name+" /etc/hosts section end here######\n\n"

print "!!!Remember to run the following command!!!\n vagrant provision"

file.close()

	
