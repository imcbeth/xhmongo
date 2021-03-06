# PRIVATE CLASS: do not call directly
class xhmongo::server::service {
  $ensure           = $xhmongo::server::service_ensure
  $service_manage   = $xhmongo::server::service_manage
  $service_enable   = $xhmongo::server::service_enable
  $service_name     = $xhmongo::server::service_name
  $service_provider = $xhmongo::server::service_provider
  $service_status   = $xhmongo::server::service_status
  $bind_ip          = $xhmongo::server::bind_ip
  $port             = $xhmongo::server::port
  $configsvr        = $xhmongo::server::configsvr
  $shardsvr         = $xhmongo::server::shardsvr

  if !$port {
    if $configsvr {
      $port_real = 27019
    } elsif $shardsvr {
      $port_real = 27018
    } else {
      $port_real = 27017
    }
  } else {
    $port_real = $port
  }

  if $bind_ip == '0.0.0.0' {
    $bind_ip_real = '127.0.0.1'
  } else {
    $bind_ip_real = $bind_ip
  }

  $service_ensure = $ensure ? {
    'absent'  => false,
    'purged'  => false,
    'stopped' => false,
    default   => true
  }

  if $service_manage {
    service { 'mongodb':
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $service_enable,
      provider  => $service_provider,
      hasstatus => true,
      status    => $service_status,
    }

    if $service_ensure {
      mongodb_conn_validator { 'xhmongo':
        server  => $bind_ip_real,
        port    => $port_real,
        timeout => '240',
        require => Service['mongodb'],
      }
    }
  }

}
