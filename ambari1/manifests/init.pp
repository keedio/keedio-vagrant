 include base
 # redirect repo request to buildoop VM
 include local-repo 

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
  include keedio
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
  require => [Package["ambari-server","ambari-agent","ambari-log4j"],Exec["ambari-setup"]]
  }
  file{'/usr/lib/ambari-server/web/javascripts/app.js.gz':
  ensure => file,
  source => 'puppet:///files/app.js.gz',
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
  exec { "ambari-setup":
  command => "ambari-server setup -s",
  cwd     => "/var/tmp",
  creates => "/var/lib/pgsql/data/postgresql.conf",
  path    => ["/usr/bin", "/usr/sbin","/sbin","/bin"],
  require => Package["ambari-server","ambari-agent","ambari-log4j"]
  }
  service { "ambari-server":
  ensure => "running",
  require => [Package["ambari-server"],Exec["ambari-setup"]],
  subscribe => File["/etc/ambari-agent/conf/ambari-agent.ini"]
  }

  }

