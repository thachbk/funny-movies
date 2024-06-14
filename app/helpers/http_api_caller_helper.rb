# frozen_string_literal: true

module HttpApiCallerHelper
  require 'net/http'

  def self.parse_response(response)
    JSON.parse response.body
  end

  def self.http_post(data, url)
    logger.info "url: #{url}***>>>**httpPost data : #{data.inspect}\n" if defined?(logger)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # http.ssl_version = :TLSv1_2 #:TLSv1_2 #:SSLv23 #:SSLv3
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = data.to_json
    res = http.request(request)
    logger.info "**>>>**httpPost data result body: #{res.body.inspect}\n" if defined?(logger)
    begin
      parse_response(res)
    rescue StandardError
      {}
    end
  end

  def self.http_get(params, url)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    begin
      parse_response(res)
    rescue StandardError
      {}
    end
  end
end
