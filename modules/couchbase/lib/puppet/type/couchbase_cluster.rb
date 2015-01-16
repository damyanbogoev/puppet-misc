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

  newparam(:server_port) do
    desc 'Couchbase server port'  
    
    defaultto 8091
  end

  newparam(:port) do
    desc 'Port to be set for the cluster(Default: 8091).'

    defaultto 8091
  end

  newparam(:ram_size) do
    desc 'Cluster RAM size to be set.'
  end
end
