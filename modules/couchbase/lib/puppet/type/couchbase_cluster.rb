Puppet::Type.newtype(:couchbase_cluster) do

  desc 'Manage a couchbase cluster.'

  validate do
    fail("cli credentials not specified.") if self[:username].nil? || self[:password].nil?
  end

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:username) do
    desc 'Username to be set for the cluster.'
  end

  newparam(:password) do
    desc 'Password to be set for the cluster.'
  end

  newparam(:port) do
    desc 'Couchbase server port'  
  end

  newproperty(:ram_size) do
    desc 'Cluster RAM size to be set.'
    munge do |value|
      Integer(value)
    end

    validate do |value|
      ram_size = Integer(value)
      unless (ram_size > 255)
        raise ArgumentError, "Quota must be between 256 MB and 80% of memory size. Specified value is #{ram_size}"
      end
    end
  end
end
