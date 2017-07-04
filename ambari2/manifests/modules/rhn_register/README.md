puppet-rhn_register
===================

[![Build Status](https://travis-ci.org/pcfens/puppet-rhn_register.svg?branch=master)](https://travis-ci.org/pcfens/puppet-rhn_register)

## Overview

Version 1.5 of this module is a fairly major overhaul, but should still be backwards compatible (but you should still test
things first).

Registers a machine with RHN or a satellite server.  If a machine
is already registered then nothing happens, unless the force
parameter is set to true.

Parameter names mostly match those used in the command itself, but are changed in some places to both preserve
backwards compatibility, and to follow the puppet parameter naming conventions. Names will all conform to the
puppet style guide when we move to 2.0 (probably the same time support for puppet 3.x will be dropped)

### class rhn_register

`rhn_register` can use the more classic `rhnreg_ks` method of registering with a satellite server,
or the newer `subscription-manager register` method. A username and password, or activation key
are required regardless of the method used. The `use_classic` parameter (default is true for
backwards compatibility) selects the method used (classic uses `rhnreg_ks`).

Using the classic ([`rhnreg_ks`](http://linux.die.net/man/8/rhnreg_ks)) method, available parameters are

* `username` (string)
* `password` (string)
* `activationkey` (string)
* `proxy` (string)
* `serverurl` (string)
* `proxyuser` (string)
* `proxypass` (string)
* `sslca` (string)
* `profilename` (string)
* `hardware` (boolean, default: true)
* `packages` (boolean, default: true)
* `virtinfo` (boolean, default: true)
* `rhnsd` (boolean, default: true)
* `force` (boolean, default: false)

Examples:
````puppet
    class { 'rhn_register':
      sslca         => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
      serverurl     => 'https://my-satellite-server.example.com/XMLRPC',
      activationkey => '1-activationkeyiwanttouse',
    }

    class { 'rhn_register':
      activationkey => '1-activationkeyiwanttouseforrhn',
    }
````

The newer [`subscription-manager register`](https://access.redhat.com/documentation/en-US/Red_Hat_Subscription_Management/1/html/RHSM/registering-cmd.html) method accepts

* `system_name` (string, defaults to undefined, which RH defaults to the hostname)
* `username` (string)
* `password` (string)
* `activationkey` (string)
* `serverurl` (string)
* `proxy` (string)
* `proxyuser` (string)
* `proxypass` (string)
* `insecure` (boolean, default: false)
* `base_url` (string)
* `unit_type` (string, maps to type argument)
* `org` (string)
* `consumer_id` (string)
* `environment` (string)
* `release` (string)
* `auto_attach` (boolean, default: true)
* `auto_subscribe` (boolean, default: false)
* `service_level` (string)

This method has not yet been fully tested for idempotency.

## Supported Platforms

This class has only been tested on RHEL6.
