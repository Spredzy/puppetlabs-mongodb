# PRIVATE CLASS: do not call directly
class mongodb::server::service {
  $ensure                    = $mongodb::server::service_ensure
  $service_enable            = $mongodb::server::service_enable
  $service_name              = $mongodb::server::service_name
  $service_provider          = $mongodb::server::service_provider
  $service_status            = $mongodb::server::service_status
  $enable_sharding           = $mongodb::server::enable_sharding
  $sharding_service_name     = $mongodb::server::sharding_service_name
  $sharding_service_enable   = $mongodb::server::sharding_service_enable
  $sharding_service_ensure   = $mongodb::server::sharding_service_ensure
  $sharding_service_status   = $mongodb::server::sharding_service_status
  $config_shard              = $mongodb::server::config_shard
  $bind_ip                   = $mongodb::server::bind_ip
  $port                      = $mongodb::server::port

  $service_ensure = $ensure ? {
    absent  => false,
    purged  => false,
    default => true
  }

  service { 'mongodb':
    ensure    => $service_ensure,
    name      => $service_name,
    enable    => $service_enable,
    provider  => $service_provider,
    hasstatus => true,
    status    => $service_status,
  }

  if $enable_sharding {
    service { 'mongos':
      ensure    => $sharding_service_ensure,
      name      => $sharding_service_name,
      enable    => $sharding_service_enable,
      provider  => $service_provider,
      hasstatus => true,
      status    => $sharding_service_status,
      subscribe => File[$config_shard],
    }
  }

  if $service_ensure {
    mongodb_conn_validator { "mongodb":
      server  => $bind_ip,
      port    => $port,
      timeout => '240',
      require => Service['mongodb'],
    }
  }
}
