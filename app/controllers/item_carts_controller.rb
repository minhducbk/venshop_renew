class ItemCartsController < ApplicationController
  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    if user_signed_in?
      cart = current_user.cart
      if cart.blank?
        cart = Cart.create(user_id: current_user.id)
        if cookies[:cart].present?
          list_items = JSON.parse(cookies[:cart])

          list_items.each do |record|
            cart_item = CartItem.find_by(item_id: record[0].to_i, cart_id: cart.id)
            if cart_item.present?
              cart_item.update_columns(quantity: (cart_item.quantity + record[1].to_i))
            else
              CartItem.create(item_id: record[0].to_i, cart_id: cart.id,
                quantity: record[1].to_i
              )
            end
          end
        end
      end
      cart_item = CartItem.find_by(item_id: item.id, cart_id: cart.id)
      if cart_item.present?
        cart_item.update_columns(quantity: (cart_item.quantity +
          params[:add_to_cart][:quantity].to_i))
      else
        CartItem.create(item_id: item.id, cart_id: cart.id,
          quantity: params[:add_to_cart][:quantity].to_i
        )
      end
    else
      cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
      if cart[item.id.to_s].present?
        cart[item.id.to_s] += params[:add_to_cart][:quantity].to_i
      else
        cart[item.id.to_s] = params[:add_to_cart][:quantity].to_i
      end
      cookies[:cart] = {
        :value => cart.to_json,
        :expires => 4.years.from_now
      }
    end
    redirect_to cart_path
  end
end
