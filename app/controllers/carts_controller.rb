class CartsController < ApplicationController
  include CartConcern

  def show
    enough_stock_to_sale_and_reload_cart?(@cart)
    @cart_items = if user_signed_in?
                    @cart.convert_to_array_of_hash
                  else
                    @cart.map do |item_id, quantity|
                      {
                        item: Item.find_by(id: item_id.to_i),
                        quantity: quantity.to_i
                      }
                    end
                  end
    @cart_subtotal = get_subtotal(@cart_items)
    @reload = params[:reload].present?
  end

  def update
    respond_to do |format|
      @cart_subtotal = params[:quantity][:subtotal].to_f
      @cart_item_quantity = params[:quantity][:quantity].to_i
      @item = Item.find_by(id: params[:quantity][:item_id].to_i)
      if user_signed_in?
        item_cart = CartItem.find_by(cart_id: @cart.id, item_id: @item.id)
        @cart_subtotal = subtotal_after_update_quantity(@cart_subtotal,
                                                        @item.price,
                                                        item_cart.quantity,
                                                        @cart_item_quantity
                                                        )
        item_cart.update_column(:quantity, @cart_item_quantity )
      else
        @cart_subtotal = subtotal_after_update_quantity(@cart_subtotal,
                                                        @item.price,
                                                        @cart["#{@item.id}"],
                                                        @cart_item_quantity
                                                        )
        @cart["#{@item.id}"] = @cart_item_quantity
        store_cart_to_cookie(@cart)
      end
      format.html {}
      format.js {}
    end
  end


  def proceed_checkout
    respond_to do |format|
      @enough_stock = enough_stock_to_sale_and_reload_cart?(@cart)
      format.html {}
      format.js {}
    end
  end
end
