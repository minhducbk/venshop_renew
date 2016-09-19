class CartsController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def show
    if request.xhr?
      respond_to do |format|
        if user_signed_in?
          cart = current_user.cart
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
        cart = current_user.cart
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

  def update
    respond_to do |format|
      @item_id = params[:quantity][:item_id].to_i
      @subtotal = params[:quantity][:subtotal].to_f
      @quantity = params[:quantity][:quantity].to_i
      item = Item.find_by(id: @item_id)
      if user_signed_in?
        cart = current_user.cart
        item_cart = CartItem.find_by(cart_id: cart.id,
          item_id: @item_id)
        @subtotal = (@subtotal - (item_cart.quantity * item.price) +
                  (@quantity*item.price)).round(2)
        item_cart.update_column(:quantity, params[:quantity][:quantity].to_i )

      else
        cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
        @subtotal = (@subtotal - (cart["#{@item_id}"].to_i * item.price) +
                  (@quantity*item.price)).round(2)
        cart["#{@item_id}"] = params[:quantity][:quantity].to_i
        cookies[:cart] = {
          value: cart.to_json,
          expires: 4.years.from_now
        }
      end
      @count_items = get_quantity(cart)
      format.html {}
      format.js {}
    end
  end

  # Destroy item in cart
  def destroy
    if user_signed_in?
      cart = current_user.cart
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
