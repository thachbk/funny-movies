# frozen_string_literal: true

class BaseCmd
  # prepend SimpleCommand
  include ActiveModel::Validations

  def initialize(params:)
    @params = params
  end

  private

  attr_reader :params

  def validate
    true
  end
end
