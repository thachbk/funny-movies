class Url
  VALID_YTB_FORMAT_REGEX = /^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/embed\/[a-zA-Z0-9_-]{11}(\?[\w=&]*)?$/i.freeze
end

class WebSocketInfo
  VIDEO_SHARING_TOPIC = 'video:new_sharing'
end