# frozen_string_literal: true

module OauthTokensConcern
  extend ActiveSupport::Concern

  def current_resource_owner
    User.find_by(id: doorkeeper_token&.resource_owner_id)
  end

  alias current_user current_resource_owner
end
