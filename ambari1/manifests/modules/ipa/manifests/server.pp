class ipa::server {
 $set_domain=hiera(set_domain)
 $set_subdomain=hiera(set_subdomain)
 $set_realm=hiera(set_realm)
 $set_master=hiera(set_master)
 $passwd=hiera(ipa_password)
  if hiera(ipa) {
  package { "ipa-server": ensure => "present"}
  package { "bind-dyndb-ldap": ensure => "present"}

  exec { 'ipa':
  command => "/usr/sbin/ipa-server-install -a $passwd --hostname=$set_master.$set_subdomain.$set_domain -r $set_realm -p $passwd -n $set_subdomain.$set_domain  -U >& /root/ipa-install.log",
  creates => "/var/lib/ipa/sysrestore/sysrestore.state",
  require => [Package['ipa-server','bind-dyndb-ldap'],Class[base]],
  logoutput => false, 
  timeout     => 1200 
  } 
  
  exec { 'kinit':
  command => "/bin/echo $passwd|/usr/bin/kinit admin > /dev/null",
  require => [Exec['ipa'],Class[base]],
  unless => [ "/usr/bin/ipa krbtpolicy-show | grep '18000'  > /dev/null"],
  logoutput => false,
  timeout     => 1200
}
    
  exec { 'ipa-conf':
  command => "/usr/bin/ipa krbtpolicy-mod --maxlife=3600 --maxrenew=18000 >& /root/ipa-conf.log && /usr/bin/kdestroy > /dev/null",
  require => [Exec['ipa','kinit'],Class[base]],
  unless => [ "/usr/bin/ipa krbtpolicy-show | grep '18000'  > /dev/null"], 
  timeout     => 1200
}

}
}
