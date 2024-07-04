# frozen_string_literal: true

class RegisterUserCmd < BaseCmd
  prepend SimpleCommand

  validates :email, presence: true
  validates :password, presence: true

  def initialize(params:)
    super(params: params)
    @email = params[:email]
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
  end

  def call
    return if invalid?

    registered_user = User.find_for_authentication(email: email)
    unless registered_user
      email_confirmation_required = ENV.fetch('EMAIL_CONFIRMATION_REQUIRED', 1).to_i.positive?

      registered_user = User.new(email: email, password: password, password_confirmation: password_confirmation)
      registered_user.skip_confirmation! unless email_confirmation_required

      unless registered_user.save
        errors.add(:base, registered_user.errors.full_messages.to_sentence)
        return
      end
    end

    unless registered_user.valid_password?(password)
      errors.add(:email, 'Email has been taken')
      return
    end
    
    registered_user
  end

  private

  attr_reader :email, :password, :password_confirmation
end
