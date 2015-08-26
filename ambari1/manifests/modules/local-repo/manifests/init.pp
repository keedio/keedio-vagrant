class  local-repo  {
file_line{'redirect repos to local VM':
           path => '/etc/hosts',
           line => '10.129.128.12  repo.keedio.org  repo',
           ensure => 'present',
          }

}
