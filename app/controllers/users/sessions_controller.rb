# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    RegisterUserCmd.call(params: user_params)
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
