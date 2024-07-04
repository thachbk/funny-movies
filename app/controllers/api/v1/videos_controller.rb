class Api::V1::VideosController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index]

  def index
    videos = Video.includes(:user).order(created_at: :desc)
    render json: json_with_success(data: videos, options: { serialize: { each_serializer: VideoSerializer, include_user: true } })
  end

  def create
    cmd = Videos::CreateCmd.call(params: video_params, user: current_user)
    if cmd.success?
      render json: json_with_success(data: cmd.result)
    else
      render json: json_with_error(message: cmd.errors.full_messages.to_sentence)
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end
end
