class { 'rhn_register':
  sslca         => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
  serverurl     => 'https://satellite.example.com/XMLRPC',
  activationkey => '1-1d6cfafaa90a972e7d3c2743e19f18cc',
}
