require 'net/http'

Puppet::Type.type(:couchbase_cluster).provide(:cli) do

  confine :osfamily => :Debian
  defaultfor :osfamily => :Debian

  commands :cli => '/opt/couchbase/bin/couchbase-cli',
           :dpkg => '/usr/bin/dpkg',
           :curl => '/usr/bin/curl'

  def exists?
    server_port = resource[:server_port]
    url = "http://localhost:#{server_port}/pools/default"
    response = Net::HTTP.get_response(URI.parse(url))

    response.code == '200' || response.code == '401'
  end

  def create
    username = resource[:username]
    password = resource[:password]
    server_port = resource[:server_port]
    port = resource[:port]
    ram_size = resource[:ram_size]

    server_address = "localhost:#{server_port}"
    additional_parameters = "--cluster-init-username=#{username} --cluster-init-password=#{password} --cluster-init-port=#{port} --cluster-init-ramsize=#{ram_size}"

    cli('cluster-init', '-c', server_address, additional_parameters)
  end
end

