# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/factories/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  config.filter_sensitive_data('Bear TOKEN') do |interaction|
    interaction.request.headers['Authorization'].first
  end

  config.allow_http_connections_when_no_cassette = true
end
