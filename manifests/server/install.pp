# PRIVATE CLASS: do not call directly
class mongodb::server::install {
  $package_ensure           = $mongodb::server::package_ensure
  $package_name             = $mongodb::server::package_name
  $enable_sharding          = $mongodb::server::enable_sharding
  $sharding_package_ensure  = $mongodb::server::sharding_package_ensure
  $sharding_package_name    = $mongodb::server::sharding_package_name

  case $package_ensure {
    true:     {
      $my_package_ensure = 'present'
      $file_ensure     = 'directory'
    }
    false:    {
      $my_package_ensure = 'absent'
      $file_ensure     = 'absent'
    }
    'absent': {
      $my_package_ensure = 'absent'
      $file_ensure     = 'absent'
    }
    'purged': {
      $my_package_ensure = 'purged'
      $file_ensure     = 'absent'
    }
    default:  {
      $my_package_ensure = $package_ensure
      $file_ensure     = 'present'
    }
  }

  package { 'mongodb_server':
    ensure  => $my_package_ensure,
    name    => $package_name,
    tag     => 'mongodb',
  }

  if $enable_sharding {
    package {'mongos' :
      ensure  => $sharding_package_ensure,
      name    => $sharding_package_name,
      tag     => 'mongodb',
    }
  }

}
