class  base  {

group { "puppet":
  ensure => "present",
 }

File { owner => 0, group => 0, mode => 0644 }

 file { '/etc/motd':
   content => "Welcome to your Vagrant-built virtual machine!
               Managed by Puppet.\n"
 }
 yumrepo { "keedio-1.2":
      baseurl => "http://repo.keedio.org/openbus/1.2/rpm",
      descr => "keedio-repository",
      enabled => 1,
      gpgcheck => 0
  }
  yumrepo { "keedio-1.2-updates":
      baseurl => "http://repo.keedio.org/openbus/1.2/updates",
      descr => "keedio-updates-repository",
      enabled => 1,
      gpgcheck => 0
  }
  yumrepo { "ambari-1.x":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA",
      descr => "Ambari",
      enabled => 1,
      gpgcheck => 0,
  }
  yumrepo { "Updates-ambari-1.x":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0",
      descr => "Ambari",
      enabled => 1,
      gpgcheck => 0,
  }
  yumrepo { "ambari-2.0.0Updates":
      baseurl => "http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.0",
      descr => "Ambari2",
      enabled => 0,
      gpgcheck => 0,
  }

  yumrepo { "epel-apache-maven":
      baseurl => "http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-6Server/x86_64/",
      descr => "maven from apache",
      enabled => 1,
      gpgcheck => 0,
  }

  yumrepo { "epel-apache-maven-source":
      baseurl => "http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-6Server/SRPMS",
      descr => "maven from apache",
      enabled => 1,
      gpgcheck => 0,
  }




  package { "yum": ensure => "installed" }
  package { "wget": ensure => "installed" }
  package { "vim-enhanced": ensure => "installed" }
  package { "apache-maven":
    ensure => "installed",
    require => Yumrepo[ "epel-apache-maven" ]
  }

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
  ensure => "running",
  } 
}
