# frozen_string_literal: true

class Videos::FetchYtbInfoCmd < BaseCmd
  prepend SimpleCommand

  BASE_URL = ENV.fetch('YOUTUBE_API_URL', 'https://www.googleapis.com/youtube/v3/videos').freeze

  validates :youtube_url, ytb_url: true, presence: true

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
    if uri.host.nil?
      return nil # Not a valid URL
    end

    if /(www\.)?youtube\.com/.match?(uri.host)
      if uri.path == '/watch'
        params = CGI.parse(uri.query)
        return params['v'][0] if params['v']
      elsif (match = uri.path.match(%r{/embed/(.+)}))
        return match[1]
      elsif (match = uri.path.match(%r{/v/(.+)})) # rubocop:disable Lint/DuplicateBranch
        return match[1]
      end
    elsif uri.host.include?('youtu.be')
      return uri.path[1..]
    end

    nil # Video ID not found
  end

  def fetch_video_info
    info = nil

    params = {
      id:   youtube_id,
      part: 'snippet',
      key:  ENV.fetch('YOUTUBE_API_KEY', nil)
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
end
