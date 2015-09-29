class ipa::server {
  if hiera(ipa) {
  package { "ipa-server": ensure => "present"}
  package { "bind-dyndb-ldap": ensure => "present"}

  exec { 'ipa':
  command => "/usr/sbin/ipa-server-install -a adminadmin --hostname=master.ambari.keedio.org -r KEEDIO.ORG -p adminadmin -n ambari.keedio.org  -U >& /root/ipa-install.log",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => [Package['ipa-server','bind-dyndb-ldap'],Class[base]], 
  timeout     => 1200 
  } 
  }   
}
