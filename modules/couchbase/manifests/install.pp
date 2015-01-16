# Provides installation of a Couchbase package
class couchbase::install {

  include wget

  $package_ensure     = $couchbase::package_ensure
  $package_name       = $couchbase::package_name
  $package_provider   = $couchbase::package_provider
  $package_source_url = $couchbase::package_source_url
  $package_source_dir = $couchbase::package_source_dir
  $package_source     = $couchbase::package_source

  file { $package_source_dir:
    ensure => directory
  }

  wget::fetch { 'download_couchbase_deb':
    source      => $package_source_url,
    destination => $package_source,
    timeout     => 0,
    verbose     => false,
  }

  package { 'couchbase-server':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
    source   => $package_source,
    notify   => Class['couchbase::service'],
  }
}
