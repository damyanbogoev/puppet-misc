# Provides installation and configuration for a Couchbase server
class couchbase(
) inherits couchbase::params {

  class { 'couchbase::install': }

  class { 'couchbase::config': }

  class { 'couchbase::bucket': }

  class { 'couchbase::service': }
}
