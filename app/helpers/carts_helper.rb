module CartsHelper
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
end
