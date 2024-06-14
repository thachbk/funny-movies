# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: user_params[:email])
    unless user
      email_confirmation_required = ENV.fetch('EMAIL_CONFIRMATION_REQUIRED', 1).to_i.positive?
      registered_user = User.new(user_params)
      registered_user.skip_confirmation! unless email_confirmation_required
      registered_user.save
    end

    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
