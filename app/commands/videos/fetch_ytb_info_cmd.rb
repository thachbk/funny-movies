# frozen_string_literal: true

class Videos::FetchYtbInfoCmd < BaseCmd
  prepend SimpleCommand

  BASE_URL = ENV.fetch('YOUTUBE_API_URL', 'https://www.googleapis.com/youtube/v3/videos').freeze

  validates :youtube_url, ytb_url: true, presence: true
  validates :youtube_api_key, presence: true

  def initialize(params:)
    super
    @youtube_url = params[:url]
  end

  def call
    return if invalid?

    @youtube_id = youtube_video_id
    return unless youtube_id_valid?

    fetch_video_info
  end

  private

  attr_reader :youtube_url, :youtube_id

  def youtube_id_valid?
    unless youtube_id
      errors.add(:base, "Youtube ID can't be blank")
      return false
    end

    true
  end

  def youtube_video_id
    uri = URI.parse(youtube_url)
    if /(www\.)?youtube\.com/.match?(uri.host)
      match = uri.path.match(%r{/embed/(.+)})
      return match[1]
    end

    nil # Video ID not found
  end

  def fetch_video_info
    info = nil

    params = {
      id:   youtube_id,
      part: 'snippet',
      key:  youtube_api_key
    }
    response = HttpApiCallerHelper.http_get(params, BASE_URL)

    if response.present? && response['items'].present? && response['items'].first['snippet'].present?
      snippet = response['items'].first['snippet']
      info = {
        title:       snippet['title'],
        description: snippet['description']
      }
    else
      errors.add(:base, 'Failed to fetch video information')
    end

    info
  end

  def youtube_api_key
    ENV.fetch('YOUTUBE_API_KEY', nil)
  end
end
