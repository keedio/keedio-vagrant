class  host-manager  {
file_line{'master_line':
           path => '/etc/hosts',
           line => '192.168.0.12  master.ambari.keedio.org  master',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
file_line{'ambari1_line':
           path => '/etc/hosts',
           line => '192.168.0.10  ambari1.ambari.keedio.org  ambari1',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
file_line{'ambari2_line':
           path => '/etc/hosts',
           line => '192.168.0.11  ambari2.ambari.keedio.org  ambari2',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
}