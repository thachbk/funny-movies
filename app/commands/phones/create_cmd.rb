class Phones::CreateCmd < BaseCmd
  prepend SimpleCommand

  validates :user, presence: true
  validates :manufacturer, :model, presence: true

  def initialize(params:, user:)
    super(params: params)
    @user = user
    @manufacturer = Manufacturer.find_by(id: params[:manufacturer_id])
    @model = Model.find_by(id: params[:model_id])
  end

  def call
    return if invalid?

    user.phones.create!(phone_params)
  end

  private

  attr_reader :user, :manufacturer, :model

  def phone_params
    params.slice(:manufacturer_id, :model_id, :memory, :year_of_manufacture, :color_body, :price)
  end
end
