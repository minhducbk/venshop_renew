class CartItemsController < ApplicationController
  include CartConcern
  include StoreCart

  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    cart_quantity = params[:add_to_cart][:quantity].to_i

    if user_signed_in?
      #store_cart_cookie_to_db
      store_cart_session_to_db
      cart_item = CartItem.find_by(item_id: item.id, cart_id: @cart.id)
      if cart_item.present?
        cart_item.update_columns(quantity: (cart_item.quantity + cart_quantity))
      else
        CartItem.create(item_id: item.id, cart_id: @cart.id, quantity: cart_quantity)
      end
    else
      if @cart[item.id.to_s].present?
        @cart[item.id.to_s] += cart_quantity
      else
        @cart[item.id.to_s] = cart_quantity
      end
      #store_cart_to_cookie(@cart)
      store_cart_to_session(@cart)
    end
    redirect_to cart_path
  end

  def destroy
    if user_signed_in?
      CartItem.find_by(item_id: params[:item_id].to_i, cart_id: @cart.id).destroy
    else
      @cart.delete(params[:item_id].to_s)
      #store_cart_to_cookie(@cart)
      store_cart_to_session(@cart)
    end
    redirect_to cart_path
  end
end
