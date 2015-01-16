# Class: couchbase::params
# The Couchbase Module default configuration settings
class couchbase::params {
  # install
  case $::osfamily {
    'Debian': {
      $package_ensure     = 'installed'
      $package_name       = 'couchbase-server'
      $package_provider   = 'dpkg'
      $package_source_url = 'http://repo3dc.telerik.com/repo/install/couchbase-server-enterprise_3.0.2-ubuntu12.04_amd64.deb'
      $package_source_dir = '/opt/couchbase'
      $package_source     = '/opt/couchbase/couchbase-server-enterprise_3.0.2-ubuntu12.04_amd64.deb'
      $version            = '3.0.2'
    }
    default: {
      fail("The ${::osfamily} based system is not supported for this module.")
    }
  }

  # service
  $service_ensure = 'running'
  $service_manage = true
  $service_name   = 'couchbase-server'
}
