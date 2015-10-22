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
  password => hiera(ambari_db_password),
  host     => '%',
  grant    => ['ALL']
} ->

mysql_user { 'ambari@localhost':
  ensure                   => 'present',
  password_hash => mysql_password(hiera(ambari_db_password)),
} ->


mysql_grant { 'ambari@localhost/ambari.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => 'ambari.*',
  user       => 'ambari@localhost',
}

mysql::db { 'oozie':
  user     => 'oozie',
  password => hiera(oozie_db_password),
  host     => '%',
  grant    => ['ALL']
} ->

mysql_user { 'oozie@localhost':
  ensure                   => 'present',
  password_hash => mysql_password(hiera(oozie_db_password)),
} ->


mysql_grant { 'oozie@localhost/oozie.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => 'oozie.*',
  user       => 'oozie@localhost',
}


mysql::db { 'hue':
  user     => 'hue',
  password => hiera(hue_db_password),
  host     => '%',
  grant    => ['ALL']
} ->

mysql_user { 'hue@localhost':
  ensure                   => 'present',
  password_hash => mysql_password(hiera(hue_db_password)),
} ->


mysql_grant { 'hue@localhost/hue.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => 'hue.*',
  user       => 'hue@localhost',
}


mysql::db { 'hive_meta':
  user     => 'hive',
  password => hiera(hive_db_password),
  host     => '%',
  grant    => ['ALL']
} ->

mysql_user { 'hive@localhost':
  ensure                   => 'present',
  password_hash => mysql_password(hiera(hive_db_password)),
} ->


mysql_grant { 'hive@localhost/hive_meta.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => 'hive_meta.*',
  user       => 'hive@localhost',
}


}

