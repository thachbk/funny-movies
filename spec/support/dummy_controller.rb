class DummyController < ApplicationController
  include ResponseHelper
  include ErrorsHandler

  def test_error_hander_action
    if 'ActionController::ParameterMissing'.eql?(params[:error])
      # this wil raise ActionController::ParameterMissing exception
      params.require(:required_param)
    end

    raise params[:error].constantize

    # rescue StandardError => exception
    #   byebug
  end
end
