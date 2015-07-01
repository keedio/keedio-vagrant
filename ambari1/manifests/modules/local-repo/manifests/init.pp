class  local-repo  {
file_line{'redirect repos to local VM':
           path => '/etc/hosts',
           line => '192.168.65.201  repo.keedio.org  repo',
           ensure => 'present',
          }

}
