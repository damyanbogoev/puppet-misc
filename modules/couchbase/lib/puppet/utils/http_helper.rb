require 'net/http'

module Puppet::Utils
  class Http_Helper

    def self.get_uri(route, hostname = 'localhost', port = 8091, ssl = false)
      protocol = if ssl then 'https' else 'http' end
      base_uri = "#{protocol}://#{hostname}:#{port}"

      URI.join(base_uri, route)
    end

    def self.execute_get_request(uri, username = nil, password = nil)
      request = Net::HTTP::Get.new(uri.to_s)

      if (username.nil? == false)
        request.basic_auth(username, password)
      end

      result = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      result
    end
  end
end