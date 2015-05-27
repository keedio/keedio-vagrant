 include base
 
  node default {
  class { 'groovy': 
    }
  package { "fuse-devel": ensure => "installed"}
  package { "fuse-libs": ensure => "installed"}
  package { "fuse": ensure => "installed"}
  package { "cmake": ensure => "installed"}
  package { "lzo-devel": ensure => "installed"}
  package { "openssl-devel": ensure => "installed"}
  package { "createrepo": ensure => "installed"}
  package { "yum-utils": ensure => "installed"}
  package { "httpd": ensure => "installed"}
  package { "git": ensure => "installed"}
  package { "redhat-rpm-config": ensure => "installed"}
  package { "rpm-build": ensure => "installed"}
  package { "glibc-devel.i686": ensure => "installed"}
  package { "elfutils-libelf.i686": ensure => "installed"}
  package { "compat-libstdc++-33.i686": ensure => "installed"}
  package { "gcc-c++": ensure => "installed"}
  package { "jdk": 
             ensure => "installed",
             require => Yumrepo["keedio-1.2"]
          }
  file {"/etc/profile.d/buildoop.sh":
         ensure  => "present",
         content => "export JAVA_HOME=/usr/java/jdk1.7.0_51\nexport PATH=/usr/java/jdk1.7.0_51/bin:\$PATH\nexport MAVEN_OPTS='-Xms512m -Xmx1024m'"
       }
  cron { "createrepo":
         ensure  => present,
         command => "createrepo --simple-md-filenames /vagrant/repo/keedio-1.2/",
         user    => 'root',
         hour    => 14,
         minute  => 0,
         require => Package["createrepo"]
       }
  file_line{'repo_root':
            path =>'/etc/httpd/conf/httpd.conf',
            line =>'DocumentRoot "/var/www/html/repo"',
            match => '^DocumentRoot *',
            require => Package['httpd'] }
  file_line{'repo_root2':
            path =>'/etc/httpd/conf/httpd.conf',
            line => '<Directory "/var/www/html/repo">',
            match => '^\<Directory "/var/www/html"\>', 
            require => Package['httpd']}
  file {'/var/www/html/repo':
         ensure => 'directory',
         require => Package['httpd']}

  service { 'httpd':
      ensure => running,
      enable => true,
      require => [Package["httpd"], File["/var/www/html/repo"]],
      subscribe => File_line["repo_root","repo_root2"]
    } 
  }  


