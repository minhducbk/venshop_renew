class CartsController < ApplicationController
  include CartConcern

  def show
    if request.xhr?
      respond_to do |format|
        @enough_stock = enough_stock_to_sale_and_reload?(@cart)
        format.html {}
        format.js {}
      end
    else
      enough_stock_to_sale_and_reload?(@cart)
      @cart_items = if user_signed_in?
                      @cart.cart_items.map do |cart_item|
                        {
                          item: Item.find_by(id: cart_item.item_id),
                          quantity: cart_item.quantity
                        }
                      end
                    else
                      @cart_items = @cart.map do |item_id, quantity|
                        {
                          item: Item.find_by(id: item_id.to_i),
                          quantity: quantity.to_i
                        }
                      end
                    end
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
        item_cart = CartItem.find_by(cart_id: @cart.id, item_id: @item_id)
        @subtotal = (@subtotal - (item_cart.quantity * item.price) +
                  (@quantity*item.price)).round(2)
        item_cart.update_column(:quantity, params[:quantity][:quantity].to_i )
      else
        @subtotal = (@subtotal - (@cart["#{@item_id}"].to_i * item.price) +
                  (@quantity*item.price)).round(2)
        @cart["#{@item_id}"] = params[:quantity][:quantity].to_i
        store_cart_to_cookie(@cart)
      end
      format.html {}
      format.js {}
    end
  end

  # Destroy item in cart
  def destroy
    if user_signed_in?
      CartItem.find_by(item_id: params[:item_id].to_i, cart_id: @cart.id).destroy
    else
      @cart.delete(params[:item_id].to_s)
      store_cart_to_cookie(@cart)
    end
    redirect_to cart_path
  end
end
