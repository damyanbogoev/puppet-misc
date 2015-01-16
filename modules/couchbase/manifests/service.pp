# Provides meands for managing the couchbase-server service
class couchbase::service {
  
  $service_name = $couchbase::service_name
  $service_ensure = $couchbase::service_ensure

  service { $service_name:
    ensure     => $service_ensure,
    hasstatus  => true,
    hasrestart => true,
  }
}
