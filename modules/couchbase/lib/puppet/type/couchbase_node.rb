Puppet::Type.newtype(:couchbase_node) do

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:username) do
    desc 'Username to be set for the cluster.'
  end

  newparam(:password) do
    desc 'Password to be set for the cluster.'
  end

  newproperty(:node) do
    desc 'Node to be added or removed from the Couchbase cluster.'  
  end
end
