# frozen_string_literal: true

module WsErrorsHandler
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def method_added(method_name) # rubocop:disable Lint/MissingSuper
      return if @_adding_method # rubocop:disable ThreadSafety/InstanceVariableInClassMethod

      @_adding_method = true # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
      original_method = instance_method(method_name)

      define_method(method_name) do |*args, &block|
        original_method.bind_call(self, *args, &block)
      rescue ActiveRecord::RecordInvalid => e
        handle_record_invalid(e)
      rescue  ActiveRecord::RecordNotFound => e
        handle_record_not_found(e)
      rescue  ActiveRecord::RecordNotUnique => e
        handle_duplicate_record(e)
      rescue  ActiveRecord::StatementInvalid => e
        handle_record_statement_invalid(e)
      rescue  ActionController::ParameterMissing => e
        handle_parameter_missing(e)
      rescue  ErrorsHandler::InvalidToken => e
        handle_bad_request(e)
      rescue  ErrorsHandler::MissingToken => e
        handle_missing_token(e)
      rescue  ActionCable::Connection::Authorization::UnauthorizedError => e
        handle_actioncable_unauthorized_error(e)
      rescue StandardError => e
        handle_general_exception(e)
      end

      @_adding_method = false # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
    end
  end

  private

  def handle_general_exception(exception)
    Rails.logger.error(exception)
  end

  def handle_record_invalid(exception)
    handle_general_exception(exception)
  end

  def handle_record_not_found(exception)
    handle_general_exception(exception)
  end

  def handle_record_statement_invalid(exception)
    handle_general_exception(exception)
  end

  def handle_parameter_missing(exception)
    handle_general_exception(exception)
  end

  def handle_bad_request(exception)
    handle_general_exception(exception)
  end

  def handle_missing_token(exception)
    handle_general_exception(exception)
  end

  def handle_duplicate_record(exception)
    handle_general_exception(exception)
  end

  def handle_actioncable_unauthorized_error(exception)
    handle_general_exception(exception)
    raise exception
  end
end
