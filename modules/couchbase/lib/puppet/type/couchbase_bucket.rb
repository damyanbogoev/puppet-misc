Puppet::Type.newtype(:couchbase_bucket) do
  
  desc 'Manage a couchbase bucket.'

  validate do
    fail("cli credentials not specified.") if self[:username].nil? || self[:password].nil?
  end

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The bucket name.'
  end

  newproperty(:port) do
    desc 'Standard port, exclusive with bucket-port'
    munge do |value|
      Integer(value)
    end

    validate do |value|
      port = Integer(value)
      unless (port >= 1024 and port <= 65536)
        raise ArgumentError, "The port number must be greater than 1023 and less than 65536. Specified value is #{port}"
      end
    end
  end

  newproperty(:size) do
    desc 'Bucket RAM quota in MB.'
    munge do |value|
      Integer(value)
    end
  end

  newparam(:type) do
    desc 'Bucket type, either memcached or couchbase.'
  
    defaultto :couchbase
    newvalues(:couchbase, :memcached)
  end

  newparam(:replica) do
    desc 'Replication count.'
    munge do |value|
      Integer(value)
    end

    newvalues(0, 1, 2, 3)
  end

  newproperty(:bucketpass) do
    desc 'Supports ASCII protocol and does not require authentication.'
  end

  newproperty(:enable_flush) do
    desc 'Enables and disables flush.'
    
    newvalues(0, 1)
  end

  newparam(:username) do
    desc 'Username used to apply couchbase-cli commands.'
  end
  
  newparam(:password) do
    desc 'Password used to apply couchbase-cli commands.'
  end
end
