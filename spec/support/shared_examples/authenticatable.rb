# frozen_string_literal: true

RSpec.shared_examples 'authenticatable' do
  context 'with invalid token' do
    let(:Authorization) { 'Bearer token' }

    it 'returns bad request' do |example|
      submit_request(example.metadata)

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
