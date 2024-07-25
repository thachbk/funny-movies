class Api::V1::PhonesController < Api::V1::BaseController
  def create
    cmd = Phones::CreateCmd.call(params: phone_params, user: current_user)
    if cmd.success?
      render json: json_with_success(data: cmd.result)
    else
      render json: json_with_error(message: cmd.errors.full_messages.to_sentence)
    end
  end

  private

  def phone_params
    params.require(:phone).permit(:manufacturer_id, :model_id, :memory, :year_of_manufacture, :color_body, :price)
  end
end
