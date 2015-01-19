# Provides means for managing of Couchbase buckets
class couchbase::bucket {
  couchbase_bucket { 'bucket01':
    port         => 10222,
    size         => 100,
    type         => 'couchbase',
    replica      => 0,
    enable_flush => 0,
    username     => 'Administrator',
    password     => 'password'
  }
}
