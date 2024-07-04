# frozen_string_literal: true

require 'swagger_helper'

RSpec.shared_context 'rswag_context' do # rubocop:disable RSpec/ContextWording
  let(:user) { create(:user) } # Assuming you have a user factory
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, expires_in: 2.hours) }

  let(:Authorization) { "Bearer #{token.token}" }
  let(:'X-API-VERSION') { 'v1' }
end
