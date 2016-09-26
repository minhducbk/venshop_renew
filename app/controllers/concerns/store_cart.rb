module StoreCart
  extend ActiveSupport::Concern

  def store_cart_cookie_to_db
    unless current_user.is_admin?
      cart = Cart.find_or_create_by(user_id: current_user.id)
      if cookies[:cart].present?
        old_cart = JSON.parse(cookies[:cart])
        copy_old_cart_to_cart_in_db(old_cart, cart)
        cookies[:cart] = nil
      end
    end
  end

  def copy_old_cart_to_cart_in_db(old_cart, cart)
    cart_items = old_cart.map do |item_id, quantity|
      cart_item = CartItem.find_by(item_id: item_id.to_i, cart_id: cart.id)
      if cart_item.present?
        cart_item.update_columns(quantity: (cart_item.quantity + quantity.to_i))
      else
        cart.cart_items.build(item_id: item_id.to_i, quantity: quantity.to_i)
      end
    end
    cart_items.map(&:save)
  end
end
