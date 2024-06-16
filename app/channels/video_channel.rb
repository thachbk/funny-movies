# frozen_string_literal: true

class VideoChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from(WebSocketInfo::VIDEO_SHARING_TOPIC)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
