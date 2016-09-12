class CartsController < ApplicationController
  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      unless cart.present?
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

  def show
    if request.xhr?
      respond_to do |format|
        if user_signed_in?
          cart = Cart.find_by(user_id: current_user.id)
        else
          cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
        end
        @enough_stock = enough_stock_to_sale_and_reload?(cart)
        format.html {}
        format.js {}
      end
    else
      @cart_items = []
      if user_signed_in?
        cart = Cart.find_by(user_id: current_user.id)
        enough_stock_to_sale_and_reload?(cart)
        @cart_items = cart.cart_items.map do |cart_item|
          [Item.find_by(id: cart_item.item_id), cart_item.quantity]
        end
      else
        cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
        enough_stock_to_sale_and_reload?(cart)
        @cart_items = cart.map do |record|
          [Item.find_by(id: record[0].to_i), record[1].to_i]
        end
      end
      @count_items = get_quantity(cart)
      @subtotal = get_subtotal(@cart_items)
      @reload = params[:reload].present?
    end
  end

  # Destroy item in cart
  def destroy
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      CartItem.find_by(item_id: params[:item_id].to_i, cart_id: cart.id).destroy
    else
      list_items = JSON.parse(cookies[:cart])
      list_items.delete(params[:item_id].to_s)
      cookies[:cart] = {
        value: list_items.to_json,
        expires: 4.years.from_now
      }
    end
    redirect_to cart_path
  end
end
