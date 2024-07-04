require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serialization) { UserSerializer.new(user) }
  let(:serialized_json) { JSON.parse(serialization.to_json) }

  it "serializes user properties correctly" do
    expect(serialized_json).to include(
      'email' => user.email,
      'created_at' => user.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
    )
  end
end