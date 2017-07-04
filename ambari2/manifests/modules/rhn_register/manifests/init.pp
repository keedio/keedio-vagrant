# == Class: rhn_register
class rhn_register (
  $use_classic    = true,
  $profilename    = undef,
  $username       = undef,
  $password       = undef,
  $activationkey  = undef,
  $hardware       = true,
  $packages       = true,
  $virtinfo       = true,
  $rhnsd          = true,
  $force          = false,
  $proxy          = undef,
  $proxyuser      = undef,
  $proxypass      = undef,
  $sslca          = undef,
  $serverurl      = undef,
  $insecure       = false,
  $base_url       = undef,
  $unit_type      = undef,
  $system_name    = undef,
  $consumer_id    = undef,
  $org            = undef,
  $release        = undef,
  $auto_attach    = true,
  $auto_subscribe = false,
  $service_level  = undef,
  $environment    = undef,
) {

  validate_bool($use_classic, $hardware, $packages, $virtinfo, $rhnsd, $force, $insecure, $auto_attach, $auto_subscribe)

  # This only works because undef passes validate_string:
  validate_string($profilename, $username, $password, $activationkey, $proxy, $proxyuser, $proxypass)
  validate_string($sslca, $serverurl, $base_url, $unit_type, $system_name, $consumer_id, $org, $release)
  validate_string($service_level, $environment)

  if $::osfamily != 'RedHat' {
    fail("You can't register ${::operatingsystem} with RHN or Satellite using this puppet module")
  }

  if $rhn_register::username == undef and $rhn_register::activationkey == undef or $activationkey == [] {
    fail('Either an activation key or username/password is required to register')
  }

  if $use_classic {
    $command = '/usr/sbin/rhnreg_ks'
    $creates_file = '/etc/sysconfig/rhn/systemid'

    $arguments = {
      'profilename'   => $rhn_register::profilename,
      'activationkey' => $rhn_register::activationkey,
      'username'      => $rhn_register::username,
      'password'      => $rhn_register::password,
      'nohardware'    => !$rhn_register::hardware,
      'nopackages'    => !$rhn_register::packages,
      'novirtinfo'    => !$rhn_register::virtinfo,
      'norhnsd'       => !$rhn_register::rhnsd,
      'proxyUser'     => $rhn_register::proxyuser,
      'proxyPassword' => $rhn_register::proxypass,
      'proxy'         => $rhn_register::proxy,
      'sslCACert'     => $rhn_register::sslca,
      'serverUrl'     => $rhn_register::serverurl,
    }

  } elsif !$use_classic {
    $command = '/usr/bin/subscription-manager register'
    $creates_file = '/etc/pki/consumer/cert.pem'

    $arguments = {
      'name'          => $rhn_register::system_name,
      'username'      => $rhn_register::username,
      'password'      => $rhn_register::password,
      'activationkey' => $rhn_register::activationkey,
      'serverurl'     => $rhn_register::serverurl,
      'proxy'         => $rhn_register::proxy,
      'proxyuser'     => $rhn_register::proxyuser,
      'proxypassword' => $rhn_register::proxypass,
      'insecure'      => $rhn_register::insecure,
      'baseurl'       => $rhn_register::base_url,
      'typeid'        => $rhn_register::unit_type,
      'consumerid'    => $rhn_register::consumer_id,
      'org'           => $rhn_register::org,
      'environment'   => $rhn_register::environment,
      'release'       => $rhn_register::release,
      'auto-attach'   => $rhn_register::auto_attach,
      'autosubscribe' => $rhn_register::auto_subscribe,
      'servicelevel'  => $rhn_register::service_level,
    }

  }

  $final_args = delete_undef_values($arguments)
  $command_flags = command_args($final_args)

  if $rhn_register::force {
    exec { 'register_with_rhn':
      command => "${command} --force ${rhn_register::command_flags}",
    }
  } else {
    exec { 'register_with_rhn':
      command => "${command} ${rhn_register::command_flags}",
      creates => $creates_file,
    }
  }
}
