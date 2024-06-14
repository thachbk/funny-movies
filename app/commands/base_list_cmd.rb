# frozen_string_literal: true

class BaseListCmd < BaseCmd
  DEFAULT_PAGE = 1
  DEFAULT_ITEMS_PER_PAGE = 25

  DESC_DIRECTION = 'desc'
  ASC_DIRECTION = 'asc'

  DEFAULT_ORDER_BY = {
    field:     'id',
    direction: ASC_DIRECTION
  }.freeze

  DEFAULT_ORDERING_SETTINGS = {
    fields:        {
      id: 'id'
    },
    default_order: DEFAULT_ORDER_BY
  }.freeze

  def initialize(params:, ordering_settings: DEFAULT_ORDERING_SETTINGS)
    super(params: params)
    @ordering_settings = ordering_settings
  end

  private

  attr_reader :params, :ordering_settings

  def default_order
    ordering_settings[:default_order] || DEFAULT_ORDER_BY
  end

  def valid_params?
    return true if page.positive? && items_per_page.positive?

    errors.add(:error, I18n.t('error_messages.error_400'))

    false
  end

  def normalize_params(params)
    direction = params[:order_direction] || DEFAULT_ORDER_BY[:direction]
    direction = direction.downcase == DESC_DIRECTION ? :desc : :asc

    {
      paging:   {
        page:           params[:page] || DEFAULT_PAGE,
        items_per_page: params[:items_per_page] || DEFAULT_ITEMS_PER_PAGE
      },
      order_by: {
        field:     params[:order_field] || DEFAULT_ORDER_BY[:field],
        direction: direction
      }
    }
  end

  def page
    @page ||= params[:page]&.to_i || params[:page_index]&.to_i
  end

  def items_per_page
    @items_per_page ||= params[:items_per_page]&.to_i || params[:page_size]&.to_i
  end

  def skip
    @skip ||= (page - 1) * items_per_page
  end

  def apply_order(query)
    order_by = params[:order_by]
    order_by = default_order unless ordering_settings[:fields].key?(order_by[:field])

    direction = order_by[:direction]
    order_field_key = order_by[:order_by][:field]

    order_field = ordering_settings[:fields][order_field_key]
    query.order(order_field => direction)
  end

  def paginate(query)
    query.limit(items_per_page).offset(skip)
  end
end
