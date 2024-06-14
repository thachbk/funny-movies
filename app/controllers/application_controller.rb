# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_out_path_for(_resource_or_scope)
    :videos
  end

  def after_sign_up_path_for(_resource)
    :videos
  end

  def after_sign_in_path_for(_resource)
    :videos
  end

  def render200
    render json: json_with_success(message: 'OK'), status: :ok
  end

  # using to response 404 status to client in case no route found
  def render404
    respond_to do |format|
      format.html { render 'home/page_not_found', status: :not_found }
      format.json { render_404_json }
    end
  end
end
