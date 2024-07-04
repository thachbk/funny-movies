# frozen_string_literal: true

module ErrorsHandler # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  class BadRequest < StandardError; end

  class SendEmailUnsuccessfully < StandardError; end

  class InvalidToken < StandardError; end

  class ExpiredSignature < StandardError; end

  class MissingToken < StandardError; end

  class MissingConfirmToken < StandardError; end

  class Forbidden < StandardError; end

  class Unprocessable < StandardError; end

  included do
    rescue_from StandardError do |exception|
      log_exception(exception)

      render json: json_with_error(
        message: I18n.t('errors.internal_server_error')
      ), status: :internal_server_error
    end

    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActiveRecord::StatementInvalid, with: :handle_record_statement_invalid
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from BadRequest, with: :handle_bad_request
    rescue_from InvalidToken, with: :handle_bad_request
    rescue_from ExpiredSignature, with: :handle_bad_request
    rescue_from SendEmailUnsuccessfully, with: :send_email_unsuccessfully
    rescue_from MissingToken, with: :handle_missing_token
    rescue_from MissingConfirmToken, with: :handle_missing_confirm_token
    rescue_from Forbidden, with: :handle_forbidden
    rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate_record
    rescue_from Unprocessable, with: :handle_unprocessable
  end

  private

  def log_exception(exception)
    Rails.logger.error(exception)
  end

  def handle_unprocessable(exception)
    log_exception(exception)

    render json: json_with_error(
      message: exception.message
    ), status: :unprocessable_entity
  end

  def handle_record_invalid(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('activerecord.errors.record_invalid', record: humanized_model_name(exception.record.class.to_s)),
      errors:  exception.record&.errors&.messages
    ), status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    log_exception(exception)

    message = exception.model ? I18n.t('activerecord.errors.record_not_found', record: humanized_model_name(I18n.t("activerecord.model_names.#{exception.model}", default: exception.model))) : exception.message
    render json: json_with_error(
      message: message
    ), status: :not_found
  end

  def handle_record_statement_invalid(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('activerecord.errors.statement_invalid')
    ), status: :unprocessable_entity
  end

  def handle_parameter_missing(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('activerecord.errors.parameters_missing')
    ), status: :bad_request
  end

  def handle_bad_request(exception)
    log_exception(exception)

    render json: json_with_error(
      message: exception.message
    ), status: :bad_request
  end

  def handle_argument_error(exception)
    log_exception(exception)

    render json: json_with_error(
      message: exception.message
    ), status: :unprocessable_entity
  end

  def humanized_model_name(model_name)
    model_name&.underscore&.humanize(keep_id_suffix: true) || 'record'
  end

  def send_email_unsuccessfully(exception)
    log_exception(exception)

    render json: json_with_error(
      message: exception.message
    ), status: :internal_server_error
  end

  def handle_missing_token(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('errors.missing_token')
    ), status: :forbidden
  end

  def handle_missing_confirm_token(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('errors.missing_confirm_token')
    ), status: :forbidden
  end

  def handle_forbidden(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('errors.forbidden')
    ), status: :forbidden
  end

  def handle_duplicate_record(exception)
    log_exception(exception)

    render json: json_with_error(
      message: I18n.t('activerecord.errors.record_existed')
    ), status: :bad_request
  end
end
