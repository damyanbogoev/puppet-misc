require 'puppet/utils/http_helper'
require 'json'

Puppet::Type.type(:couchbase_node).provide(:cli) do

  confine :osfamily => :Debian
  defaultfor :osfamily => :Debian

  commands :cli  => '/opt/couchbase/bin/couchbase-cli',
           :curl => "/usr/bin/curl"

  def self.instances(resource)
    uri = Puppet::Utils::Http_Helper.get_uri("/pools/default")
    result = Puppet::Utils::Http_Helper.execute_get_request(uri, resource[:username], resource[:password])

    resources = []

    data = JSON.parse(result.body)
    data["nodes"].each.collect do |item|
      entry = { :name   => item["hostname"],
                :ensure => :present}

      resources << new(entry)
    end

    resources
  end

  def self.prefetch(resources)
    resources.each do |name, resource|
      nodes = self.instances(resource)
      if provider = nodes.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush[:creation] = true
    @property_hash[:ensure] = :present
  end

  def destroy
    @property_flush[:deletion] = true

    @property_hash.clear
  end

  def flush
    options = ['-c', 'localhost:8091', '-u', resource[:username], '-p', resource[:password]]
    command = 'rebalance'
    if @property_flush     
      if @property_flush[:creation]
        (options << "--server-add=#{resource[:name]}")
        (options << "--server-add-username=#{resource[:username]}")
        (options << "--server-add-password=#{resource[:password]}")
      else
        (options << "--server-remove=#{resource[:name]}")
      end
      unless options.empty?
        cli(command, options)
      end
    end

    @property_hash = resource.to_hash
  end
end
