# frozen_string_literal: true

module ResponseHelper
  extend ActiveSupport::Concern

  SUCCESS_STATUS = :success
  ERROR_STATUS   = :fail

  def json_with_pagination(message: :success, data: nil, custom_serializer: nil, options: {})
    {
      status:  SUCCESS_STATUS,
      message: message,
      data:    data ? pagination_json(data, custom_serializer: custom_serializer, options: options) : nil
    }
  end

  def json_with_success(message: :success, data: nil, options: {})
    instance_options           = options[:serialize] || {}
    instance_options[:include] = '**'
    {
      status:  SUCCESS_STATUS,
      message: options[:message] || message || 'Success',
      data:    data ? ActiveModelSerializers::SerializableResource.new(data, instance_options).as_json : nil
    }
  end

  def json_with_error(message: :fail, errors: nil, error_code: nil)
    {
      status:     ERROR_STATUS,
      message:    message,
      errors:     errors,
      error_code: error_code
    }
  end

  private

  def pagination_json(data, custom_serializer: nil, options: {})
    pagination =
      if data.respond_to?(:cursor)
        {
          cursor: data.cursor
        }
      else
        {
          limit_value:  data.respond_to?(:limit_value) && data.limit_value ? data.limit_value : 0,
          current_page: data.respond_to?(:current_page) ? data.current_page : 1,
          next_page:    data.respond_to?(:next_page) ? data.next_page : nil,
          prev_page:    data.respond_to?(:prev_page) ? data.prev_page : nil,
          total_pages:  data.respond_to?(:total_pages) ? data.total_pages : 1
        }
      end

    options           = { each_serializer: custom_serializer }.merge(options) if custom_serializer
    options[:include] = '**'

    {
      pagination: pagination,
      items:      ActiveModelSerializers::SerializableResource.new(data, options).as_json
    }
  end
end
