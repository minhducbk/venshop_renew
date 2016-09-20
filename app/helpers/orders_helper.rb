module OrdersHelper
  def get_name_products(order)
    quantity = order.order_items.inject(0) do |quantity, order_item|
      quantity + order_item.quantity.to_i
    end
    first_item = Item.find_by(id: order.order_items[0].item_id)
    prefix = (order.order_items[0].quantity.to_i == 1) ?
      "#{first_item.name}" : "#{order.order_items[0].quantity} #{first_item.name}"
    if order.order_items.count == 1
      prefix
    else
      "#{prefix} and #{quantity - order.order_items[0].quantity.to_i} other products"
    end
  end

  def get_order_quantity(order)
    order.order_items.inject(0) do |quantity, order_item|
      quantity + order_item.quantity.to_i
    end
  end
end
