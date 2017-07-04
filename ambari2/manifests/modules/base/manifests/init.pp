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

if hiera(satellite) == true {
      contain spacewalk
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

 if hiera(nameresolution) == 'aws' {
    file{'/etc/hosts':
         ensure => file,
         source => 'puppet:///files/aws_hosts',
         owner  => 'root',
         mode   =>  0644
    }
 } 

 if hiera(nameresolution) == 'azure' {
    file{'/etc/hosts':
         ensure => file,
         source => 'puppet:///files/az_hosts',
         owner  => 'root',
         mode   =>  0644
    }
 }

if hiera(nameresolution) == 'script' {
     contain host-manager
 }  

 if hiera(disable_repos) == true {
 $isenabled = 0
 }
 else {
 $isenabled = 1
 }

 yumrepo { "epel":
      baseurl => "http://mirror.de.leaseweb.net/epel/7/x86_64",
      descr => "epel",
      enabled => $isenabled,
      gpgcheck => 0
  }

  yumrepo { "ambari-2.x":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3",
      descr => "Ambari",
      enabled => $isenabled,
      gpgcheck => 1,
      gpgkey => "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins",
      priority => 1,
 }

  if hiera(development)  {
      yumrepo { "epel-apache-maven":
         baseurl => "http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-7Server/x86_64/",
         descr => "maven from apache",
         enabled => $isenabled,
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
  service { "firewalld":
  ensure => "stopped",
  enable => false
  }
  
}
