module OrdersHelper
  def get_name_products(order)
    first_item = Item.find_by(id: order.order_items[0].item_id)
    quantity = 0
    order.order_items.map{|order_item| quantity += order_item.quantity.to_i}
    prefix = (order.order_items[0].quantity.to_i == 1) ?
      "#{first_item.name}" : "#{order.order_items[0].quantity.to_i} #{first_item.name}"
    if order.order_items.count == 1
      prefix
    else
      "#{prefix} and #{quantity - order.order_items[0].quantity.to_i} other products"
    end
  end

  # Conver order to array, format each element is [item_object, quantity]
  def convert_order_to_array(order)
    order.order_items.map{|order_item|
      [Item.find_by(id: order_item.item_id), order_item.quantity.to_i]
    }
  end
end
