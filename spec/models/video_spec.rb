# == Schema Information
#
# Table name: videos
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string           not null
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_videos_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:video) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:url) }

    it 'returns an error if url is incorrect format' do
      video = build(:video, :with_invalid_url)
      video.valid?
      expect(video.errors[:url]).to be_present
    end

    it 'returns valid if url is correct format' do
      video = build(:video, :with_valid_url)
      video.valid?
      expect(video.errors[:url]).to be_empty
    end
  end
end
