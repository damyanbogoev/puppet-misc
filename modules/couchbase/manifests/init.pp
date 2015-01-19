# Provides installation and configuration for a Couchbase server
class couchbase(
  $package_ensure = $couchbase::params::package_ensure,
  $version = $couchbase::params::version,
  $service_ensure = $couchbase::params::service_ensure
) inherits couchbase::params {

  class { 'couchbase::install': }

  class { 'couchbase::config': }

  class { 'couchbase::bucket': }

  class { 'couchbase::service': }
}
