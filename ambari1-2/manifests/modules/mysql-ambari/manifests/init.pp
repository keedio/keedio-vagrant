class   mysql-ambari {
class { '::mysql::server':
  root_password           => hiera(db_password),
  remove_default_accounts => true,
  override_options      => {
        mysqld => { bind-address => '0.0.0.0'} 
      },
}

mysql::db { 'ambari':
  user     => 'ambari',
  password => 'ambari',
  host     => '%',
  grant    => ['ALL']
}

mysql::db { 'oozie':
  user     => 'oozie',
  password => hiera(oozie_db_password),
  host     => '%',
  grant    => ['ALL']
}


#mysql_grant { 'oozie@%/*.*':
#  ensure     => 'present',
#  options    => ['GRANT'],
#  privileges => ['ALL'],
#  table      => '*.*',
#  user       => 'oozie@%',
#}


mysql::db { 'hue':
  user     => 'hue',
  password => hiera(hue_db_password),
  host     => '%',
  grant    => ['ALL']
}

#mysql_grant { 'hue@%/hue.*':
#  ensure     => 'present',
#  options    => ['GRANT'],
#  privileges => ['ALL'],
#  table      => 'hue.*',
#  user       => 'hue@%',
#}

mysql::db { 'hive':
  user     => 'hive',
  password => hiera(hive_db_password),
  host     => '%',
  grant    => ['ALL']
}


}

