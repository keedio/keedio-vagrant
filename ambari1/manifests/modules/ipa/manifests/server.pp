class ipa::server {

  package { "ipa-server": ensure => "present"}

  exec { 'ipa':
  command => "/usr/sbin/ipa-server-install -a adminadmin --hostname=master.ambari.keedio.org -r KEEDIO.ORG -p adminadmin -n ambari.keedio.org -U >& /root/ipa-install.log",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => Package['ipa-server'], 
  timeout     => 1200 
 }   
}
