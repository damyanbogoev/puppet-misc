Puppet::Type.newtype(:couchbase_cluster) do
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
  end
end
