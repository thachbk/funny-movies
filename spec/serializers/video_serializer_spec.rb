require 'rails_helper'

RSpec.describe VideoSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:video) { create(:video, :with_valid_url, user: user) }
  let(:serialization) { VideoSerializer.new(video) }
  let(:serialized_json) { JSON.parse(serialization.to_json) }

  it "serializes video properties correctly" do
    expect(serialized_json).to include(
      'title' => video.title,
      'description' => video.description,
      'url' => video.url,
      'created_at' => video.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
    )
  end

  context 'when include_user is true' do
    let(:serialization) { VideoSerializer.new(video, include_user: true) }
    let(:serialized_json) { JSON.parse(serialization.to_json) }

    it "serializes video properties correctly with user included" do
      expect(serialized_json).to include(
        'title' => video.title,
        'description' => video.description,
        'url' => video.url,
        'created_at' => video.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
        'user' => {
          'id' => video.user.id,
          'email' => video.user.email,
          'created_at' => video.user.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
        }
      )
    end
  end
end
