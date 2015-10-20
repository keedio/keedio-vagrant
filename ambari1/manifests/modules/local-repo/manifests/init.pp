class  local-repo  {

$address = hiera('repo_address') ? {
    'local'          => '192.168.65.201  repo.keedio.org  repo',
    'public'         => '193.146.28.58  repo.keedio.org  repo',
    'office'         => '192.168.2.8  repo.keedio.org  repo',
    'cediant'         => '10.129.128.12  repo.keedio.org  repo',
    default          => '193.146.28.58  repo.keedio.org  repo',
}
file_line{'redirect repos to local VM':
           path => '/etc/hosts',
           line => $address,
           ensure => 'present',
          }
}
