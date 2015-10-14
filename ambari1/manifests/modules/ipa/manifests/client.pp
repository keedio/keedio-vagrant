class   ipa::client {
 $set_domain=hiera(set_domain)
 $set_subdomain=hiera(set_subdomain)
 $set_realm=hiera(set_realm)
 $set_master=hiera(set_master)
 if hiera(ipa) {
 package { "ipa-client": ensure => "installed"}
 package { "ipa-admintools": ensure => "installed"}
 exec { 'ipa':
  command => "/usr/sbin/ipa-client-install -U --server=$set_master.$set_subdomain.$set_domain  --domain=$set_subdomain.$set_domain  -w adminadmin -p admin",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => [Package['ipa-client','ipa-admintools'],Class['base']],
  timeout     => 1200
 } 
 }
}
