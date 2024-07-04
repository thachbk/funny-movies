# frozen_string_literal: true

require 'webmock'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before do
    WebMock.reset!
  end
end
