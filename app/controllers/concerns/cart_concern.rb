module CartConcern
  extend ActiveSupport::Concern

  def store_cart_to_cookie(cart)
    cookies[:cart] = {
      value: cart.to_json,
      expires: 4.years.from_now
    }
  end

  def enough_stock_to_sale_and_reload?(cart)
    enough = true
    if cart.class == Cart
      cart.cart_items.each do |cart_item|
        item = Item.find_by(id: cart_item.item_id)
        if item.stock < cart_item.quantity
          enough = false
          if item.stock.zero?
            cart_item.destroy
          else
            cart_item.update_columns(quantity: item.stock)
          end
        end
      end
      cart.cart_items.reload
    else
      cart.each do |key, value|
        item = Item.find_by(id: key.to_i)
        if item.stock < value.to_i
          enough = false
          if item.stock.zero?
            cart.delete(key)
          else
            cart[key] = item.stock
          end
        end
      end
      store_cart_to_cookie(cart)
    end
    enough
  end
end
