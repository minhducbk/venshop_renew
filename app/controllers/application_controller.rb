class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_categories
  before_action :get_cart
  helper_method :get_subtotal, :convert_order_to_array_of_hash

  private

  def get_categories
    @categories = Category.all
  end

  def get_cart
    if user_signed_in?
      @cart = current_user.cart
    else
      @cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
    end
  end

  def get_subtotal(list_items)
    subtotal = 0
    list_items.each do |list_item|
      subtotal += list_item[:item].price*list_item[:quantity]
    end
    subtotal.round(2)
  end

  def convert_order_to_array_of_hash(order)
    order.order_items.map do |order_item|
      {
        item: Item.find_by(id: order_item.item_id),
        quantity: order_item.quantity.to_i
      }
    end
  end
end
