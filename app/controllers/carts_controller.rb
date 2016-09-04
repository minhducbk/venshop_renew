class CartsController < ApplicationController

  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      unless cart.present?
        cart = Cart.create(user_id: current_user.id)
      end
      CartItem.create(item_id: item.id, cart_id: cart.id,
        quantity: params[:add_to_cart][:quantity])
    else
      list_items = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : []
      list_items << [item.id, params[:add_to_cart][:quantity]]
      cookies[:cart] = {
        :value => list_items.to_json,
        :expires => 4.years.from_now
      }
    end
    redirect_to category_path(item.category.id)
  end
end
