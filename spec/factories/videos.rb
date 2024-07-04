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
FactoryBot.define do
  factory :video do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }

    association :user

    trait :with_valid_url do
      url { 'https://www.youtube.com/embed/zcDuLuy2zL8?si=ENjc5zS9NtPWBnu4' }
    end

    trait :with_invalid_url do
      url { Faker::Internet.url }
    end
  end
end
