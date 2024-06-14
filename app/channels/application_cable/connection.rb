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
      # cookies.encrypted['_session']['user_id']
      # request.params[:token]
      if (verified_user = User.find_by(id: cookies.encrypted[:user_id]))
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def params
      Rack::Utils.parse_nested_query(env['QUERY_STRING']).with_indifferent_access
    end
  end
end
