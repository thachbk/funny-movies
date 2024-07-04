# frozen_string_literal: true

module HttpApiCallerHelper
  require 'net/http'

  def self.parse_response(response)
    JSON.parse response.body
    rescue StandardError
    {}
  end

  def self.http_post(data, url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = data.to_json
    res = http.request(request)

    parse_response(res)
  end

  def self.http_get(params, url)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    
    parse_response(res)
  end
end
