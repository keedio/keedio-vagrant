class  host-manager  {
file_line{'isban1_line':
           path => '/etc/hosts',
           line => '192.10.0.8  isban1.keedio.prbes.lab  isban1',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
file_line{'ambari21_line':
           path => '/etc/hosts',
           line => '192.10.0.30  ambari21.keedio.prbes.lab  ambari21',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
file_line{'ambari22_line':
           path => '/etc/hosts',
           line => '192.10.0.31  ambari22.keedio.prbes.lab  ambari22',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
file_line{'ambari23_line':
           path => '/etc/hosts',
           line => '192.10.0.32  ambari23.keedio.prbes.lab  ambari23',
        notify  => Service['ambari-agent'],
          ensure => 'present',
          }
}