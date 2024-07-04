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
      flash.now[:alert] = cmd.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end
end
