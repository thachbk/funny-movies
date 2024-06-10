# frozen_string_literal: true

class Api::BaseController < ActionController::API
  include OauthTokensConcern
  include ResponseHelper
  include ErrorsHandler

  before_action :doorkeeper_authorize!

  def render200
    render json: json_with_success(message: 'OK'), status: :ok
  end

  # using to response 404 status to client in case no route found
  def render404
    render json: json_with_error(message: I18n.t('errors.no_route_found')), status: :not_found
  end

  private

  def raise_bad_request(message = I18n.t('errors.bad_request'))
    raise BadRequest, message
  end

  def raise_not_found(message = I18n.t('errors.record_not_found'))
    raise ActiveRecord::RecordNotFound, message
  end

  def raise_unprocessable(message)
    raise Unprocessable, message
  end

  def raise_forbidden(message = I18n.t('errors.forbidden'))
    raise Forbidden, message
  end

  def raise_service_unavailable(message = I18n.t('errors.service_unavailable'))
    raise ServiceUnAvailable, message
  end
end
