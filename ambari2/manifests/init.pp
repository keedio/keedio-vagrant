 include base
 
  node default {
  package { "ambari-agent":
    ensure => "installed",
    require => Yumrepo[ "ambari-1.x" ]
  }
  package { "ambari-server":
    ensure => "absent",
    require => Yumrepo[ "ambari-1.x" ]
  }
  file{'/etc/ambari-agent/conf/ambari-agent.ini':
  ensure => file,
  source => 'puppet:///files/ambari-agent.ini',
  require => Package["ambari-agent"]
  }
  service { "ambari-agent":
  ensure => "running",
  require => Package["ambari-agent"],
  subscribe => File["/etc/ambari-agent/conf/ambari-agent.ini"]
  }
  }


  node 'master' {
  package { "ambari-server":
    ensure => "installed",
    require => Yumrepo[ "ambari-1.x","Updates-ambari-1.x" ]
  }
  package { "ambari-agent":
    ensure => "installed",
    require => Yumrepo[ "ambari-1.x","Updates-ambari-1.x" ]
  }
  package { "ambari-log4j":
    ensure => "installed",
    require => Yumrepo[ "ambari-1.x" ]
  }
  package { "jdk":
    ensure => "present",
    require => Yumrepo[ "keedio-1.2" ]
  }
  file{'/etc/ambari-server/conf/ambari.properties':
  ensure => file,
  source => 'puppet:///files/ambari.properties',
  require => Package["ambari-server","ambari-agent","ambari-log4j"]
  }
  file { '/var/lib/ambari-server/resources/stacks/FLUME':
  ensure => 'link',
  target => '/vagrant/files/keedio-stacks/FLUME/',
  require => Package["ambari-server","ambari-agent","ambari-log4j"]
  }
  file { '/var/lib/ambari-server/resources/stacks/KEEDIO':
  ensure => 'link',
  target => '/vagrant/files/keedio-stacks/KEEDIO/',
  require => Package["ambari-server","ambari-agent","ambari-log4j"]
  }
  }

