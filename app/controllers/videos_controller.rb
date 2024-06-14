# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @videos = Video.includes(:user).order(created_at: :desc)
  end

  def new
    @video = Video.new
  end

  def create
    cmd = Videos::CreateCmd.call(params: video_params, user: current_user)
    if cmd.success?
      redirect_to :videos
    else
      flash.now[:alert] = t(cmd.errors.full_messages.to_sentence)
      redirect_to :new_video # , status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end

  # Truncates the description to 100 characters and adds "..." at the end if it's longer
  def truncate_description(description, length: 100)
    if description.length > length
      "#{description[0...length]}..."
    else
      description
    end
  end
end
