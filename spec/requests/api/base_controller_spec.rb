require 'rails_helper'

RSpec.describe Api::BaseController do
  before do
    # Stub the doorkeeper_authorize! method
    allow_any_instance_of(described_class).to receive(:doorkeeper_authorize!).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

  describe 'POST /render404' do
    it 'returns http not_found' do
      post '/no_route_found.json', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /render404' do
    it 'returns http not_found' do
      put '/no_route_found', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /render404' do
    it 'returns http not_found' do
      delete '/no_route_found', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /render404' do
    it 'returns http not_found' do
      patch '/no_route_found', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /render404' do
    it 'returns http not_found' do
      get '/no_route_found', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
