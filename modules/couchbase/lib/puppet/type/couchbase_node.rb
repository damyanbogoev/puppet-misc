Puppet::Type.newtype(:couchbase_node) do

  desc 'Manage a couchbase node.'

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
end
