Groovy Puppet Module
======

This module will download and setup groovy from the official Codehaus' repository.


Usage
-----

```puppet
class { 'groovy':
}

```

This will install Groovy 2.3.1 into `/opt/groovy-2,3,1` and install
`/etc/profile.d/groovy.sh` to which will update the `PATH` and `GROOVY_HOME`
appropriately for bash users.

License
-------

[Apache License, Version 2.0](LICENSE-2.0.txt)

Support
-------

Please log issues at our [Projects site](https://github.com/jenkins-infra/puppet-groovy/issues)
