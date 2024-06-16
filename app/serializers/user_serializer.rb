class UserSerializer < BaseSerializer
  attributes :id, :email,
             :authentication_token,
             :created_at


  def created_at
    object.created_at.utc
  end

  def authentication_token
    object.access_tokens.last&.token
  end
end
