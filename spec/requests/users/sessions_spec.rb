require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "POST /create" do
    context 'when user has been registered' do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end

      context 'when user is not confirmed' do
        let(:user) { create(:user) }

        it 'does not log the user in' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when user is confirmed' do
        let(:user) do
          user = build(:user)
          user.skip_confirmation!
          user.save!
          user
        end

        it 'logs the user in' do
          expect(controller.current_user).to eq user
          expect(response).to redirect_to(:videos)
        end
      end

      context 'when password is invalid' do
        let(:user) do
          user = build(:user)
          user.skip_confirmation!
          user.save!

          user.password = 'invalid password'
          user
        end

        it 'does not log the user in' do
          expect(controller).to be_instance_of(CustomFailure)
          expect(response).to redirect_to(root_path)
        end
      end
    end
    
    context 'when user has not been registered' do
      before do
        allow(ENV).to receive(:fetch).with('EMAIL_CONFIRMATION_REQUIRED', 1).and_return(email_confirmation_required)
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end
      let(:email_confirmation_required) { '0' }

      context 'when email & password is valid, but require email comfirmation' do
        let(:user) { build(:user) }
        let(:email_confirmation_required) { '1' }

        it 'does not log the user in' do
          expect(controller).to be_instance_of(CustomFailure)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when email & password is valid, and does not require email comfirmation' do
        let(:user) { build(:user) }

        it 'logs the user in' do
          expect(controller.current_user).to eq User.find_for_authentication(email: user.email)
          expect(response).to redirect_to(:videos)
        end
      end
    end

    context 'when email is invalid format' do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end

      let(:user) { build(:user, email: 'invalid email') }

      it 'does not log the user in' do
        expect(controller).to be_instance_of(CustomFailure)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
