class ItemCartsController < ApplicationController
  include CartConcern

  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    if user_signed_in?
      if @cart.blank?
        @cart = Cart.create(user_id: current_user.id)
      end

      if cookies[:cart].present?
        old_cart = JSON.parse(cookies[:cart])

        cart_items = old_cart.each do |item_id, quantity|
          cart_item = CartItem.find_by(item_id: key.to_i, cart_id: @cart.id)
          if cart_item.present?
            @cart_item.update_columns(quantity: (cart_item.quantity + quantity.to_i))
          else
            @cart.cart_items.build(item_id: item_id.to_i, quantity: quantity.to_i)
          end
        end
        cart_items.each{|cart_item| cart_item.save}
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
      if @cart[item.id.to_s].present?
        @cart[item.id.to_s] += params[:add_to_cart][:quantity].to_i
      else
        @cart[item.id.to_s] = params[:add_to_cart][:quantity].to_i
      end
      store_cart_to_cookie(@cart)
    end
    redirect_to cart_path
  end
end
