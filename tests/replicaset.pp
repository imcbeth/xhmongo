node default {
  class { '::xhmongo::globals':
    manage_package_repo => true
  } ->
  class { '::xhmongo::server':
    smallfiles => true,
    bind_ip    => ['0.0.0.0'],
    replset    => 'rsmain'
  }
  mongodb_replset{'rsmain':
    members => ['mongo1:27017', 'mongo2:27017', 'mongo3:27017' ],
    arbiter => 'mongo3:27017',
  }
}
