require 'swagger_helper'

RSpec.describe 'api/oauth_tokens' do
  path '/oauth/token' do
    post 'Create a token' do
      include_context 'rswag_context'
      tags 'OAuth Tokens'
      security [api_version: []]
      produces 'application/json'
      parameter name: :grant_type, in: :query, schema: { type: :string }, required: true
      parameter name: :email, in: :query, schema: { type: :string }, required: true
      parameter name: :password, in: :query, schema: { type: :string }, required: true

      let(:user) { create(:user) }
      let(:grant_type) { 'password' }

      context 'when valid email & password' do
        let(:email) { user.email }
        let(:password) { user.password }

        response '200', 'token created' do
          schema type:       :object,
                 properties: {
                   access_token: { type: :string },
                   token_type:   { type: :string },
                   expires_in:   { type: :integer },
                   created_at:   { type: :integer }
                 },
                 required:   %w[access_token token_type expires_in created_at]

          run_test!
        end
      end

      context 'when valid email & invalid password' do
        let(:email) { user.email }
        let(:password) { 'invalid_password' }

        response '200', 'email has ben taken' do
          schema type:       :object,
                 properties: {
                   status:     { type: :string },
                   message:    { type: :string },
                   errors:     { type: [:array, :null] },
                   error_code: { type: [:integer, :null] }
                 },
                 required:   %w[status message]

          run_test!
        end
      end

      context 'when invalid email' do
        let(:email) { 'invalid_email' }
        let(:password) { 'invalid_password' }

        response '200', 'email is not correct format' do
          schema type:       :object,
                 properties: {
                   status:     { type: :string },
                   message:    { type: :string },
                   errors:     { type: [:array, :null] },
                   error_code: { type: [:integer, :null] }
                 },
                 required:   %w[status message]

          run_test!
        end
      end

      context 'when new valid email' do
        let(:new_user) { build(:user) }
        let(:email) { new_user.email }
        let(:password) { new_user.password }

        response '200', 'new use has been registerd and token created' do
          schema type:       :object,
                 properties: {
                   access_token: { type: :string },
                   token_type:   { type: :string },
                   expires_in:   { type: :integer },
                   created_at:   { type: :integer }
                 },
                 required:   %w[access_token token_type expires_in created_at]

          run_test!
        end
      end
    end
  end
end
