require 'rails_helper'

RSpec.describe 'Videos', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/videos'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get '/videos/new'
        expect(controller).to be_instance_of(CustomFailure)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in user
      end

      let(:user) { create(:user, confirmed_at: Time.zone.now) }

      it 'returns http success' do
        get '/videos/new'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /create' do
    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        video_params = { video: { url: 'http://example.com/video.mp4' } }
        expect do
          post '/videos', params: video_params
        end.not_to change(Video, :count)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in user

        video_create_cmd_instance = instance_double(Videos::CreateCmd)
        allow(Videos::CreateCmd).to receive(:call).and_return(video_create_cmd_instance)
        # allow(video_create_cmd_instance).to receive(:success?).and_return(cmd_result_status)
        error_messages = ['Error message']
        errors_double = instance_double(ActiveModel::Errors, full_messages: error_messages)
        allow(video_create_cmd_instance).to receive_messages(success?: cmd_result_status, errors: errors_double)
        allow(error_messages).to receive(:to_sentence).and_return('Error message')
      end

      let(:user) { create(:user, confirmed_at: Time.zone.now) }

      context 'when video url is not valid' do
        let(:cmd_result_status) { false }

        it 'returns http unprocessable_entity' do
          video_params = { video: { url: 'invalid url' } }
          expect do
            post '/videos', params: video_params
          end.not_to change(Video, :count)
          expect(response).to have_http_status(422)
          expect(flash.now[:alert]).to eq('Error message')
        end
      end

      context 'when video url is valid' do
        let(:cmd_result_status) { true }

        it 'creates a video' do
          video_params = { video: { url: 'http://example.com/video.mp4' } }
          post '/videos', params: video_params
          expect(response).to redirect_to(:videos)
        end
      end
    end
  end
end
