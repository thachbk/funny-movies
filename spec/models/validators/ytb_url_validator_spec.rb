require 'rails_helper'

RSpec.describe YtbUrlValidator do
  subject { described_class.new(attributes: [:url]).validate_each(record, :url, value) }

  context 'when url is not present' do
    let(:record) { build(:video, url: nil) }
    let(:value) { record.url }

    it 'returns an error' do
      subject
      expect(record.errors[:url]).to be_present
    end
  end

  context 'when url is not in correct format' do
    let(:record) { build(:video, :with_invalid_url) }
    let(:value) { record.url }

    it 'returns an error' do
      subject
      expect(record.errors[:url]).to be_present
    end
  end

  context 'when url is in correct format' do
    let(:record) { build(:video, :with_valid_url) }
    let(:value) { record.url }

    it 'does not return an error' do
      subject
      expect(record.errors[:url]).to be_blank
    end
  end
end
