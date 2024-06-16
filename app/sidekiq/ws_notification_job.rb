class WsNotificationJob
  include Sidekiq::Job

  def perform(topic, payload)
    ActionCable.server.broadcast(topic, payload)
  end
end
