require 'rails_helper'

RSpec.describe VideoChannel, type: :channel do
  let(:channel) { described_class.new(stub_connection, {}) }

  describe '#subscribed' do
    it 'subscribes to topics' do
      subscribe

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from(WebSocketInfo::VIDEO_SHARING_TOPIC)
    end
  end
end
