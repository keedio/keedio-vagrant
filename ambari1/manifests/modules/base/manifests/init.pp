class  base  {


class { 'timezone':
    timezone => 'Europe/Madrid',
}

user { "apache":
 ensure => "present", 
 uid => 48, 
 gid => 48,
 require => Group['apache']
}



group { 'puppet':
  ensure => "present",
 }
group { 'apache':
  ensure => "present",
  gid => 48
 }

exec { 'alternativesjava':
       command => 'alternatives --install /usr/bin/java java /usr/java/default/bin/java 200000',
       require => Package['chkconfig'],
       timeout => 1200,
       provider => shell, 
       unless => 'if [ "$(readlink /etc/alternatives/java)" = "/usr/java/default/bin/java" ]'
      }



File { owner => 0, group => 0, mode => 0644 }

 file { '/etc/motd':
   content => "Welcome to your Keedio-vagrant virtual machine!
               Managed by Puppet.\n"
 }


 if hiera(nameresolution) == 'static' {
    file{'/etc/hosts':
         ensure => file,
         source => 'puppet:///files/hosts',
         owner  => 'root',
         mode   =>  0644
    } 
 }
 
if hiera(nameresolution) == 'script' {
     contain host-manager
 }  

 yumrepo { "epel":
      baseurl => "http://mirror.de.leaseweb.net/epel/6/x86_64",
      descr => "epel",
      enabled => 0,
      gpgcheck => 0
  }

  yumrepo { "ambari-1.x":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA",
      descr => "Ambari",
      enabled => 0,
      gpgcheck => 0,
  }
  yumrepo { "Updates-ambari-1.x":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0",
      descr => "Ambari",
      enabled => 0,
      gpgcheck => 0,
  }
  yumrepo { "ambari-2.0.0Updates":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.0",
      descr => "Ambari2",
      enabled => 0,
      gpgcheck => 0,
  }

  if hiera(development)  {
      yumrepo { "epel-apache-maven":
         baseurl => "http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-6Server/x86_64/",
         descr => "maven from apache",
         enabled => 0,
         gpgcheck => 0,
  }
  }




  package { "yum": ensure => "installed" }
  package { "chkconfig": ensure => "installed" }
  package { "wget": ensure => "installed" }
  package { "git": ensure => "installed" }
  package { "vim-enhanced": ensure => "installed" }
  package { "yum-plugin-priorities": ensure => "installed" }
  package { "python-requests": ensure => "installed" }

  file{'/root/.ssh/authorized_keys':
  ensure => file,
  source => 'puppet:///files/.ssh/authorized_keys',
  owner  => 'root',
  mode   =>  0600 
  }
  
  file{'/root/.ssh/id_rsa':
  ensure => file,
  source => 'puppet:///files/.ssh/id_rsa',
  owner  => 'root',
  mode   =>  0600
  }
  service { "iptables":
  ensure => "stopped",
  enable => false
  }
  
}
