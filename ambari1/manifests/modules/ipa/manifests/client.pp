class   ipa::client {
 if hiera(ipa) {
 package { "ipa-client": ensure => "installed"}
 package { "ipa-admintools": ensure => "installed"}
 exec { 'ipa':
  command => "/usr/sbin/ipa-client-install -U --server=master.ambari.keedio.org --domain=ambari.keedio.org  -w adminadmin -p admin",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => [Package['ipa-client','ipa-admintools'],Class['base']],
  timeout     => 1200
 } 
 }
}
