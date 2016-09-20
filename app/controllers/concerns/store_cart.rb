module StoreCart
  extend ActiveSupport::Concern

  def store_cart_cookie_to_db
    if current_user.role == User.role_users[:customer]
      cart = current_user.cart
      cart = Cart.create(user_id: current_user.id) if cart.blank?
      if cookies[:cart].present?
        old_cart = JSON.parse(cookies[:cart])
        cart_items = old_cart.map do |item_id, quantity|
          cart_item = CartItem.find_by(item_id: item_id.to_i, cart_id: cart.id)
          if cart_item.present?
            cart_item.update_columns(quantity: (cart_item.quantity + quantity.to_i))
          else
            cart.cart_items.build(item_id: item_id.to_i, quantity: quantity.to_i)
          end
        end
        cart_items.each{|cart_item| cart_item.save}
        cookies[:cart] = nil
      end
    end
  end
end
