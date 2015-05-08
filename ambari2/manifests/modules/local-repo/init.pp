class  local-repo  {
file_line{'redirect repos to local VM':
           path => '/etc/hosts',
           line => '192.168.67.101  repo.keedio.org  repo',
           ensure => 'present',
          }

}
