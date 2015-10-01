class ipa::server {
 $set_domain=hiera(set_domain)
 $set_subdomain=hiera(set_subdomain)
 $set_realm=hiera(set_realm)

  if hiera(ipa) {
  package { "ipa-server": ensure => "present"}
  package { "bind-dyndb-ldap": ensure => "present"}

  exec { 'ipa':
  command => "/usr/sbin/ipa-server-install -a adminadmin --hostname=master.$set_subdomain.$set_domain -r $set_realm -p adminadmin -n $set_subdomain.$set_domain  -U >& /root/ipa-install.log",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => [Package['ipa-server','bind-dyndb-ldap'],Class[base]], 
  timeout     => 1200 
  } 
  }   
}
