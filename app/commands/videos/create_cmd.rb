# frozen_string_literal: true

class Videos::CreateCmd < BaseCmd
  prepend SimpleCommand

  validates :user, presence: true

  def initialize(params:, user:)
    super(params: params)
    @user = user
  end

  def call
    return if invalid?

    cmd = Videos::FetchYtbInfoCmd.call(params: params)
    unless cmd.success?
      errors.add(:base, cmd.errors.full_messages.to_sentence)
      return
    end

    video = user.videos.create!(
      title:       cmd.result[:title],
      description: cmd.result[:description],
      url:         params[:url]
    )

    # Broadcast the new video to all subscribers
    payload = {
      title: video.title,
      user_email:  user.email
    }.as_json
    WsNotificationJob.perform_async(WebSocketInfo::VIDEO_SHARING_TOPIC, payload)

    video
  end

  private

  attr_reader :user
end
