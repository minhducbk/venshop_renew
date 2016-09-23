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
    @cart = if user_signed_in?
              current_user.cart
            else
              cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
            end
  end

  def get_subtotal(list_items)
    list_items.inject(0) do |subtotal, list_item|
      subtotal + list_item[:item].price*list_item[:quantity]
    end.round(2)
  end
end
