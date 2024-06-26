require 'rails_helper'

RSpec.describe "Videos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/videos/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/videos/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/videos/create"
      expect(response).to have_http_status(:success)
    end
  end

end
