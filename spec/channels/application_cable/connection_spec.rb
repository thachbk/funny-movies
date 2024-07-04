# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  # security of socket done by TLS installed on the web server, method find_verified_account_type is not used except for testing purpose
  describe '#connect' do
    subject { connect '/cable' }

    context 'when verified_user not found' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:find_verified_user)
          .and_raise(ActionCable::Connection::Authorization::UnauthorizedError)
      end

      it 'rejects connection' do
        expect { subject }.to have_rejected_connection
      end
    end

    context 'when verified_user found' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:find_verified_user)
          .and_return(true)
      end

      it 'sets current_user' do
        subject
        expect(connection.current_user).to be_truthy
      end
    end
  end
end
