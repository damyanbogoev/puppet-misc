require 'puppet/utils/http_helper'
require 'json'

Puppet::Type.type(:couchbase_bucket).provide(:cli) do

  confine :osfamily => :Debian
  defaultfor :osfamily => :Debian

  commands :cli  => '/opt/couchbase/bin/couchbase-cli',
           :curl => "/usr/bin/curl"

  def self.instances(resource)
    uri = Puppet::Utils::Http_Helper.get_uri("/pools/default/buckets")
    result = Puppet::Utils::Http_Helper.execute_get_request(uri, resource[:username], resource[:password])

    resources = []

    data = JSON.parse(result.body)
    data.each.collect do |bucket|
      entry = {:name  => bucket['name'],
        :ensure       => :present,
        :port         => bucket['proxyPort'],
        :size         => bucket['quota']['rawRAM'],
        :replica      => bucket['vBucketServerMap']['numReplicas'],
        :bucketpass   => bucket['saslPassword'],
        :enable_flush => process_enable_flush(bucket['controllers']['flush'])
      }

      resources << new(entry)
    end

    resources
  end

  def self.process_enable_flush(value)
    if value.nil? then '0' else '1' end
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
    @property_flush[:size] = resource[:size] if resource[:size]
    @property_flush[:port] = resource[:port] if resource[:port]
    @property_flush[:replica] = resource[:replica] if resource[:replica]
    @property_flush[:bucketpass] = resource[:bucketpass] if resource[:bucketpass]
    @property_flush[:enable_flush] = resource[:enable_flush] if @resource[:enable_flush]
  end

  def destroy
    @property_flush[:deletion] = true
    @property_flush[:name] = resource[:name]

    @property_hash.clear
  end

  def size
    Integer(@property_hash[:size]) / (1024 * 1024)
  end

  def size=(value)
    @property_flush[:size] = value
  end

  def port
    @property_hash[:port]
  end

  def port=(value)
    @property_flush[:port] = value
  end

  def bucketpass
    @property_hash[:bucketpass]
  end

  def bucketpass=(value)
    @property_flush[:bucketpass] = value
  end

  def enable_flush
    @property_hash[:enable_flush]
  end

  def enable_flush=(value)
    @property_flush[:enable_flush] = value
  end

  def flush
    options = []
    if @property_flush
      (options << "--bucket=#{resource[:name]}")
      (options << "--bucket-ramsize=#{@property_flush[:size]}") if @property_flush[:size]
      (options << "--bucket-port=#{@property_flush[:port]}") if @property_flush[:port]
      (options << "--bucket-replica=#{@property_flush[:replica]}") if @property_flush[:replica]
      (options << "--bucket-password=#{@property_flush[:bucketpass]}") if @property_flush[:bucketpass]
      (options << "--enable-flush=#{@property_flush[:enable_flush]}") if @property_flush[:enable_flush]

      unless options.empty?
        if @property_flush[:creation]
          command = 'bucket-create'
        elsif @property_flush[:deletion]
          command = 'bucket-delete'
        else
          command = 'bucket-edit'
        end

        cli(command, '-c', 'localhost:8091', '-u', resource[:username], '-p', resource[:password], options)
      end
    end

    @property_hash = resource.to_hash
  end
end
