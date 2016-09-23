module CartsHelper
  def get_cart_quantity(cart)
    quantity = 0
    if cart.class == Cart
      cart.cart_items.each do |cart_item|
        quantity += cart_item.quantity.to_i
      end
    else
      quantity = cart.values.sum
    end
    quantity
  end
end
