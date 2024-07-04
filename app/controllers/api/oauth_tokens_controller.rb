class Api::OauthTokensController < Doorkeeper::TokensController
  include ResponseHelper
  include ErrorsHandler

  def create
    cmd = RegisterUserCmd.call(params: user_params)

    if cmd.success?
      super
    else
      render json: json_with_error(message: cmd.errors.full_messages.to_sentence)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end