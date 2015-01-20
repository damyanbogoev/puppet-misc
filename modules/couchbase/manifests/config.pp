# Provides configuration means for Couchbase Server
class couchbase::config {

  $cluster_username = $couchbase::cluster_username
  $cluster_password = $couchbase::cluster_password
  $cluster_port     = $couchbase::cluster_port
  $cluster_ram_size = $couchbase::cluster_ram_size

  couchbase_cluster { 'default':
    username => $cluster_username,
    password => $cluster_password,
    port     => $cluster_port,
    ram_size => $cluster_ram_size,
  }

  couchbase_node { '192.168.68.31:8091':
    ensure   => present,
    username => $cluster_username,
    password => $cluster_password,
  }
}