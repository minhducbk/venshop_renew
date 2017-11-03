module CartConcern
  extend ActiveSupport::Concern

  def store_cart_to_cookie(cart)
    cookies[:cart] = {
      value: cart.to_json,
      expires: 4.years.from_now
    }
  end

  def store_cart_to_session(cart)
    session[:cart] = cart.to_yaml
  end

  def enough_stock_to_sale_and_reload_cart?(cart)
    if cart.class == Cart
      is_enough = enough_stock_to_sale_cart_in_db?(cart)
      cart.cart_items.reload
    else
      is_enough = enough_stock_to_sale_cart_in_cookie?(cart)
      #store_cart_to_cookie(cart)
      store_cart_to_session(cart)
    end
    is_enough
  end

  def enough_stock_to_sale_cart_in_db?(cart)
    is_enough = true
    cart.cart_items.each do |cart_item|
      item = Item.find_by(id: cart_item.item_id)
      if item.stock < cart_item.quantity
        is_enough = false
        if item.stock.zero?
          cart_item.destroy
        else
          cart_item.update_columns(quantity: item.stock)
        end
      end
    end
    is_enough
  end

  def enough_stock_to_sale_cart_in_cookie?(cart)
    is_enough = true
    cart.each do |key, value|
      item = Item.find_by(id: key.to_i)
      if item.stock < value.to_i
        is_enough = false
        if item.stock.zero?
          cart.delete(key)
        else
          cart[key] = item.stock
        end
      end
    end
    is_enough
  end

  def subtotal_after_update_quantity(cart_subtotal, item_price, old_quantity, new_quantity)
    (cart_subtotal - (old_quantity * item_price) + (new_quantity * item_price)).round(2)
  end
end
