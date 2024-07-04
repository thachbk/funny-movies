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
class VideoSerializer < BaseSerializer
  attributes :id, :title, :description, :url, :created_at

  belongs_to :user, serializer: UserSerializer, if: -> { @instance_options[:include_user] }

  def created_at
    object.created_at.utc
  end

  def include_user?
    @instance_options[:include_user]
  end
end
