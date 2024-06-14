# frozen_string_literal: true

class YtbUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Url::VALID_YTB_FORMAT_REGEX.match?(value)

    record.errors.add attribute, (options[:message] || 'is not an valid YTB url')
  end
end
