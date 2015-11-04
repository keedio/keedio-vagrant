class  spacewalk  {
 $certificate_name = hiera(certificate_name)

 package { $certificate_name:
     provider => 'rpm',
     ensure => installed,
     source => hiera(certificate_rpm) 
 } ->

 yumrepo { "spacewalk-client-el6":
      baseurl => hiera(satellite_public_repo),
      descr => "Spacewalk Client Install EL6",
      enabled => 1,
      gpgcheck => 0
  }

   package { "rhn-client-tools":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
  }
  package { "rhn-check":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
  }
  package { "rhn-setup":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
  }
  package { "rhnsd":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
  }
  package { "m2crypto":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
 }
  package { "yum-rhn-plugin":
    ensure => "present",
    require => Yumrepo[ "spacewalk-client-el6" ]
 }
  
 class { 'rhn_register':
  sslca         => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT ',
  serverurl     => hiera(satellite_server),
  activationkey => hiera(activation_key),
  require => Package ['rhn-client-tools','rhn-check','rhn-setup','rhnsd','m2crypto','yum-rhn-plugin']
} 

}
