class  office-repo  {
file_line{'redirect repos to local VM':
           path => '/etc/hosts',
           line => '192.168.2.8  repo.keedio.org  repo',
           ensure => 'present',
          }

}
