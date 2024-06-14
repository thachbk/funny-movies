# frozen_string_literal: true

class Videos::CreateCmd < BaseCmd
  prepend SimpleCommand

  validates :user, presence: true

  def initialize(params:, user:)
    super(params: params)
    @user = user
  end

  def call
    return if invalid?

    cmd = Videos::FetchYtbInfoCmd.call(params: params)
    unless cmd.success?
      errors.add(:base, cmd.errors.full_messages.to_sentence)
      return
    end

    user.videos.create!(
      title:       cmd.result[:title],
      description: cmd.result[:description],
      url:         params[:url]
    )
  end

  private

  attr_reader :user
end
