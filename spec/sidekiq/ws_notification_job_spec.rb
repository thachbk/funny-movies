require 'rails_helper'
RSpec.describe WsNotificationJob, type: :job do
  describe '.perform_async' do
    subject { described_class.perform_async(topic, payload) }

    let(:topic) { 'topic' }
    let(:payload) { 'payload' }

    it 'enqueues a job' do
      # expect { subject }.to change(described_class.jobs, :size).by(1)
      subject
      expect(described_class).to have_enqueued_sidekiq_job(topic, payload).on('default')
    end
  end

  describe '.perform' do
    subject { described_class.new.perform(topic, payload) }

    let(:topic) { 'topic' }
    let(:payload) { 'payload' }

    it 'broadcasts a message' do
      allow(ActionCable.server).to receive(:broadcast).with(topic, payload)

      subject
      expect(ActionCable.server).to have_received(:broadcast).with(topic, payload)
    end
  end
end
