# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include WsErrorsHandler

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # TODO: Implement token verification for mobile app here. For now, we will just ignore this check due to FE demo purpose.
      return
    end
  end
end
