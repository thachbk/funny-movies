class VideoSerializer < BaseSerializer
  attributes :id, :title, :description, :url, :created_at

  def created_at
    object.created_at.utc
  end
end
