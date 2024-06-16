class Api::OauthTokensController < Doorkeeper::TokensController
  include ResponseHelper
  include ErrorsHandler

  # Example: Override the create method
  def create
    # user = User.find_for_authentication(email: user_params[:email])
    # unless user
    #   email_confirmation_required = ENV.fetch('EMAIL_CONFIRMATION_REQUIRED', 1).to_i.positive?
    #   registered_user = User.new(user_params)
    #   registered_user.skip_confirmation! unless email_confirmation_required
    #   registered_user.save
    # end
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