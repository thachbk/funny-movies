require 'rails_helper'

RSpec.describe Videos::CreateCmd do
  describe '.call' do
    subject { described_class.call(params: params, user: user) }

    let(:user) { create(:user) }
    let(:video) { build(:video, :with_valid_url) }
    let(:params) { { url: video.url } }

    context 'when user is not present' do
      let(:user) { nil }

      it 'returns an error' do
        expect(subject.errors[:user]).to be_present
      end

      it 'does not create a video' do
        expect { subject }.not_to change(Video, :count)
      end

      it 'does not return a video' do
        expect(subject.result).to be_nil
      end
    end

    context 'when url is not present' do
      let(:params) { { url: nil } }

      it 'returns an error' do
        expect(subject.errors[:base]).to be_present
      end

      it 'does not create a video' do
        expect { subject }.not_to change(Video, :count)
      end

      it 'does not return a video' do
        expect(subject.result).to be_nil
      end
    end

    context 'when url is not in correct format' do
      let(:video) { build(:video, :with_invalid_url) }

      it 'returns an error' do
        expect(subject.errors[:base]).to be_present
      end

      it 'does not create a video' do
        expect { subject }.not_to change(Video, :count)
      end

      it 'does not return a video' do
        expect(subject.result).to be_nil
      end
    end

    context 'when params are valid' do
      before do
        fetch_ytb_info_cmd_instance = instance_double(Videos::FetchYtbInfoCmd)
        allow(Videos::FetchYtbInfoCmd).to receive(:call).and_return(fetch_ytb_info_cmd_instance)
        allow(fetch_ytb_info_cmd_instance).to receive_messages(success?: true, result: {
          title:       video.title,
          description: video.description,
          url:         video.url
        })
      end

      it 'creates a video' do
        expect { subject }.to change(Video, :count).by(1)
      end

      it 'returns a video' do
        expect(subject.result).to be_a(Video)
      end
    end
  end
end
