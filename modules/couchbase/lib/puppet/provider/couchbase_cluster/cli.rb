require 'puppet/utils/http_helper'
require 'json'

Puppet::Type.type(:couchbase_cluster).provide(:cli) do

  confine :osfamily => :Debian
  defaultfor :osfamily => :Debian

  commands :cli => '/opt/couchbase/bin/couchbase-cli',
           :dpkg => '/usr/bin/dpkg',
           :curl => '/usr/bin/curl'

  def self.instances(resource)
    uri = Puppet::Utils::Http_Helper.get_uri("/pools/default")
    result = Puppet::Utils::Http_Helper.execute_get_request(uri, resource[:username], resource[:password])

    resources = []
    if result.code == '404'
      entry = {:name  => 'default',
          :ensure => :absent,
        } 
    else
      data = JSON.parse(result.body)
      entry = {:name  => 'default',
          :ensure => :present,
          :ram_size   => data['storageTotals']['ram']['quotaTotal'],
        } 
    end
  
    resources << new(entry)

    resources
  end

  def self.prefetch(resources)
    resources.each do |name, resource|
      buckets = instances(resource)
      if provider = buckets.find{ |pkg| pkg.name == name }
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

    @property_flush[:name] = resource[:name]
    @property_flush[:ram_size] = resource[:ram_size] if resource[:ram_size]
    @property_flush[:port] = resource[:port] if resource[:port]
  end

  def destroy
    @property_flush[:deletion] = true
    @property_flush[:name] = resource[:name]

    @property_hash.clear
  end

  def ram_size
    Integer(@property_hash[:ram_size]) / (1024 * 1024)
  end

  def ram_size=(value)
    @property_flush[:ram_size] = value
  end

  def flush
    options = ['-c', 'localhost:8091']
    if @property_flush
      if @property_flush[:creation]
        command = 'cluster-init'
        (options << "--cluster-init-username=#{resource[:username]}")
        (options << "--cluster-init-password=#{resource[:password]}")
        (options << "--cluster-init-port=#{@property_flush[:port]}") if @property_flush[:port]
        (options << "--cluster-init-ramsize=#{@property_flush[:ram_size]}") if @property_flush[:ram_size]
      else
        command = 'cluster-edit'
        options << ['-u', resource[:username], '-p', resource[:password]]
        (options << "--cluster-ramsize=#{@property_flush[:ram_size]}") if @property_flush[:ram_size]
      end
      unless options.empty?
        cli(command, options)
      end
    end

    @property_hash = resource.to_hash
  end
end

