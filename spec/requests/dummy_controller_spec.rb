require 'rails_helper'

RSpec.describe DummyController, type: :controller do
  describe 'errors_handler' do
    subject { get :test_error_hander_action, params: { error: exception_class } }

    before do
      routes.draw { get 'test_error_hander_action', to: 'dummy#test_error_hander_action' }
    end

    after do
      Rails.application.reload_routes!
    end

    describe 'rescue ActiveRecord::RecordInvalid' do
      let(:exception_class) { 'ActiveRecord::RecordInvalid' }

      it 'responds with the correct status and message' do
        subject
        expect(response).to have_http_status(422)
        expect(response.parsed_body).to include('message' => I18n.t('activerecord.errors.record_invalid'))
      end
    end

    describe 'rescue ActiveRecord::RecordNotFound' do
      let(:exception_class) { 'ActiveRecord::RecordNotFound' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(404)
        expect(response.parsed_body).to include('message' => 'ActiveRecord::RecordNotFound')
      end
    end

    describe 'rescue ActiveRecord::StatementInvalid' do
      let(:exception_class) { 'ActiveRecord::StatementInvalid' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(422)
        expect(response.parsed_body).to include('message' => I18n.t('activerecord.errors.statement_invalid'))
      end
    end

    describe 'rescue ActionController::ParameterMissing' do
      let(:exception_class) { 'ActionController::ParameterMissing' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(400)
        expect(response.parsed_body).to include('message' => I18n.t('activerecord.errors.parameters_missing'))
      end
    end

    describe 'rescue ArgumentError' do
      let(:exception_class) { 'ArgumentError' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(422)
        expect(response.parsed_body).to include('message' => 'ArgumentError')
      end
    end

    describe 'rescue BadRequest' do
      let(:exception_class) { 'ErrorsHandler::BadRequest' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(400)
        expect(response.parsed_body).to include('message' => 'ErrorsHandler::BadRequest')
      end
    end

    describe 'rescue InvalidToken' do
      let(:exception_class) { 'ErrorsHandler::InvalidToken' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(400)
        expect(response.parsed_body).to include('message' => 'ErrorsHandler::InvalidToken')
      end
    end

    describe 'rescue ExpiredSignature' do
      let(:exception_class) { 'ErrorsHandler::ExpiredSignature' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(400)
        expect(response.parsed_body).to include('message' => 'ErrorsHandler::ExpiredSignature')
      end
    end

    describe 'rescue SendEmailUnsuccessfully' do
      let(:exception_class) { 'ErrorsHandler::SendEmailUnsuccessfully' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(500)
        expect(response.parsed_body).to include('message' => 'ErrorsHandler::SendEmailUnsuccessfully')
      end
    end

    describe 'rescue MissingToken' do
      let(:exception_class) { 'ErrorsHandler::MissingToken' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(403)
        expect(response.parsed_body).to include('message' => I18n.t('errors.missing_token'))
      end
    end

    describe 'rescue MissingConfirmToken' do
      let(:exception_class) { 'ErrorsHandler::MissingConfirmToken' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(403)
        expect(response.parsed_body).to include('message' => I18n.t('errors.missing_confirm_token'))
      end
    end

    describe 'rescue Forbidden' do
      let(:exception_class) { 'ErrorsHandler::Forbidden' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(403)
        expect(response.parsed_body).to include('message' => I18n.t('errors.forbidden'))
      end
    end

    describe 'rescue ActiveRecord::RecordNotUnique' do
      let(:exception_class) { 'ActiveRecord::RecordNotUnique' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(400)
        expect(response.parsed_body).to include('message' => I18n.t('activerecord.errors.record_existed'))
      end
    end

    describe 'rescue Unprocessable' do
      let(:exception_class) { 'ErrorsHandler::Unprocessable' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(422)
        expect(response.parsed_body).to include('message' => 'ErrorsHandler::Unprocessable')
      end
    end

    describe 'rescue StandardError' do
      let(:exception_class) { 'StandardError' }

      it 'responds with the correct status and message' do
        subject

        expect(response).to have_http_status(500)
        expect(response.parsed_body).to include('message' => I18n.t('errors.internal_server_error'))
      end
    end
  end

  describe 'response_helper' do
    describe '.json_with_pagination' do
      context 'when there is no paging info' do
        let(:data) { [] }

        it 'returns the correct hash' do
          expect(controller.json_with_pagination(data: data)).to eq(
            status:  :success,
            message: :success,
            data:    {
              items:      [],
              pagination: { current_page: 1, next_page: nil, prev_page: nil, total_pages: 1, limit_value: 0 }
            }
          )
        end
      end

      context 'when there is paging info' do
        before do
          create_list(:video, 10, :with_valid_url)
        end

        let(:data) { Video.paginate(page: 1, per_page: 5) }

        it 'returns the correct hash' do
          expected_result = Video.take(5).map do |video|
            {
              id:          video.id,
              title:       video.title,
              description: video.description,
              url:         video.url,
              created_at:  video.created_at
            }
          end
          expect(controller.json_with_pagination(data: data)).to eq(
            status:  :success,
            message: :success,
            data:    {
              items:      expected_result,
              pagination: { current_page: 1, next_page: 2, prev_page: nil, total_pages: 2, limit_value: 5 }
            }
          )
        end
      end
    end

    describe '.json_with_success' do
      context 'when there is no data' do
        let(:data) { [] }

        it 'returns the correct hash' do
          expect(controller.json_with_success(data: data)).to eq(status: :success, message: :success, data: data)
        end
      end

      context 'when there is data' do
        let(:data) { [{ 'key' => 'value' }] }

        it 'returns the correct hash' do
          expect(controller.json_with_success(data: data)).to eq(status: :success, message: :success, data: data)
        end
      end
    end

    describe '.json_with_error' do
      context 'when error params are not set' do
        it 'returns the correct hash' do
          expect(controller.json_with_error).to eq(status: :fail, message: :fail, errors: nil, error_code: nil)
        end
      end

      context 'when error params are set' do
        let(:message) { 'error message' }
        let(:errors) { ['error message 1'] }
        let(:error_code) { 400 }

        it 'returns the correct hash' do
          expect(controller.json_with_error(message: message, errors: errors, error_code: error_code)).to eq(status: :fail, message: message, errors: errors, error_code: error_code)
        end
      end
    end
  end
end
