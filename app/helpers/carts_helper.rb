module CartsHelper
  def get_current_cart
    if user_signed_in?
      Cart.find_by(user_id: current_user.id)
    else
      cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
    end
  end

  def get_quantity(cart)
    quantity = 0
    if cart.class == Cart
      cart.cart_items.each do |cart_item|
        quantity += cart_item.quantity.to_i
      end
    else
      cart.each do |record|
        quantity += record[1].to_i
      end
    end
    quantity
  end

  def get_subtotal(cart)
    subtotal = 0
    cart.each do |record|
      subtotal += record[0].price*record[1]
    end
    subtotal.round(2)
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
    end
    enough
  end
end
