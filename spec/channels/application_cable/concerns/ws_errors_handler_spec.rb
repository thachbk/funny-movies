# frozen_string_literal: true

# require 'app/channels/application_cable/concerns/ws_errors_handler'
require 'rails_helper'

RSpec.describe WsErrorsHandler do
  class DummyClass
    include WsErrorsHandler

    def raise_exception(exception)
      raise exception
    end
  end

  let(:channel) { DummyClass.new }
  let(:ex) { StandardError.new('test') }

  describe 'rescues_exception' do
    subject { channel.raise_exception(ex) }

    before do
      allow(channel).to receive(:handle_general_exception).and_return(nil)
      allow(channel).to receive(:handle_record_invalid).and_return(nil)
      allow(channel).to receive(:handle_record_not_found).and_return(nil)
      allow(channel).to receive(:handle_record_statement_invalid).and_return(nil)
      allow(channel).to receive(:handle_parameter_missing).and_return(nil)
      allow(channel).to receive(:handle_bad_request).and_return(nil)
      allow(channel).to receive(:handle_missing_token).and_return(nil)
      allow(channel).to receive(:handle_duplicate_record).and_return(nil)
      allow(channel).to receive(:handle_actioncable_unauthorized_error).and_return(nil)

      subject
    end

    context 'when exception is StandardError' do
      it 'captures StandardError' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    context 'when exception is ActiveRecord::RecordInvalid' do
      let(:ex) do
        user = User.new
        ActiveRecord::RecordInvalid.new(user)
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_record_invalid)
      end
    end

    context 'when exception is ActiveRecord::RecordNotFound' do
      let(:ex) { ActiveRecord::RecordNotFound.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_record_not_found)
      end
    end

    context 'when exception is ActiveRecord::StatementInvalid' do
      let(:ex) { ActiveRecord::StatementInvalid.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_record_statement_invalid)
      end
    end

    context 'when exception is ActionController::ParameterMissing' do
      let(:ex) { ActionController::ParameterMissing.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_parameter_missing)
      end
    end

    context 'when exception is InvalidToken' do
      let(:ex) { ErrorsHandler::InvalidToken.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_bad_request)
      end
    end

    context 'when exception is MissingToken' do
      let(:ex) { ErrorsHandler::MissingToken.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_missing_token)
      end
    end

    context 'when exception is ActiveRecord::RecordNotUnique' do
      let(:ex) { ActiveRecord::RecordNotUnique.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_duplicate_record)
      end
    end

    context 'when exception is ActionCable::Connection::Authorization::UnauthorizedError' do
      let(:ex) { ActionCable::Connection::Authorization::UnauthorizedError.new('test') }

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_actioncable_unauthorized_error)
      end
    end
  end

  describe 'private methods' do
    describe '#handle_general_exception' do
      subject { channel.send(:handle_general_exception, ex) }

      before do
        allow(Rails.logger).to receive(:error).and_return(nil)

        subject
      end

      it 'logs exception' do
        expect(Rails.logger).to have_received(:error)
      end
    end

    describe '#handle_record_invalid' do
      subject { channel.send(:handle_record_invalid, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_record_not_found' do
      subject { channel.send(:handle_record_not_found, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_record_statement_invalid' do
      subject { channel.send(:handle_record_statement_invalid, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_parameter_missing' do
      subject { channel.send(:handle_parameter_missing, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_bad_request' do
      subject { channel.send(:handle_bad_request, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_missing_token' do
      subject { channel.send(:handle_missing_token, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_duplicate_record' do
      subject { channel.send(:handle_duplicate_record, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
      end
    end

    describe '#handle_actioncable_unauthorized_error' do
      subject { channel.send(:handle_actioncable_unauthorized_error, ex) }

      before do
        allow(channel).to receive(:handle_general_exception).and_return(nil)
        allow(channel).to receive(:raise).and_return(nil)

        subject
      end

      it 'handles by right handler' do
        expect(channel).to have_received(:handle_general_exception)
        expect(channel).to have_received(:raise)
      end
    end
  end
end
