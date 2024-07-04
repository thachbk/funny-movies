require 'rails_helper'

RSpec.describe Videos::FetchYtbInfoCmd do
  describe '.call' do
    subject { described_class.call(params: params) }

    context 'when url is not present' do
      let(:params) { { url: nil } }

      it 'returns an error' do
        expect(subject.errors[:youtube_url]).to be_present
      end

      it 'does not return a Ytb video info' do
        expect(subject.result).to be_nil
      end
    end

    context 'when url is not in correct format' do
      let(:params) { { url: 'invalid_url' } }

      it 'returns an error' do
        expect(subject.errors[:youtube_url]).to be_present
      end

      it 'does not return a Ytb video info' do
        expect(subject.result).to be_nil
      end
    end

    context 'when youtube_id is not included' do
      let(:video) { build(:video, url: 'http://www.youtube.com/embed?si=ENjc5zS9NtPWBnu4') }
      let(:params) { { url: video.url } }

      it 'returns an error' do
        expect(subject.errors[:youtube_url]).to be_present
      end
    end

    context 'when url is in correct format' do
      let(:video) { build(:video, :with_valid_url) }
      let(:params) { { url: video.url } }

      context 'when response is not successful' do
        it 'returns an error' do
          allow(HttpApiCallerHelper).to receive(:http_get).and_return({})
          expect(subject.errors[:base]).to be_present
        end
      end

      context 'when response is successful' do
        it 'returns a Ytb video info' do
          allow(HttpApiCallerHelper).to receive(:http_get).and_return({
            'items' => [{
              'snippet' => {
                'title' => video.title,
                'description' => video.description
              }
            }]
          })

          expect(subject.result).to eq({
            title: video.title,
            description: video.description
          })
        end
      end
    end
  end
end
