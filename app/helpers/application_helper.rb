# frozen_string_literal: true

module ApplicationHelper
  def truncate_description(description, length: 100)
    if description.length > length
      "#{description[0...length]}..."
    else
      description
    end
  end
end
