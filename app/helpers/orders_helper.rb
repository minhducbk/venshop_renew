module OrdersHelper
  def get_name_products(order)
    first_item = Item.find_by(id: order.order_items[0].item_id)
    quantity = 0
    order.order_items.map do |order_item|
      quantity += order_item.quantity.to_i
    end
    prefix = (order.order_items[0].quantity.to_i == 1) ?
      "#{first_item.name}" : "#{order.order_items[0].quantity} #{first_item.name}"
    if order.order_items.count == 1
      prefix
    else
      "#{prefix} and #{quantity - order.order_items[0].quantity.to_s} other products"
    end
  end

  # Conver order to array, format each element is [item_object, quantity]
  def convert_order_to_array(order)
    order.order_items.map do |order_item|
      [Item.find_by(id: order_item.item_id), order_item.quantity.to_i]
    end
  end

  def after_cancel(order)
    order.order_items.each do |order_item|
      item = Item.find_by(id: order_item.item_id)
      item.update_columns(stock: (item.stock + order_item.quantity.to_i))
    end
  end

  def satisfy_new?(order)
    order.order_items.each do |order_item|
      item = Item.find_by(id: order_item.item_id)
      return false if item.stock < order_item.quantity.to_i
    end
    order.order_items.each do |order_item|
      item = Item.find_by(id: order_item.item_id)
      item.update_columns(stock: (item.stock - order_item.quantity.to_i))
    end
    true
  end
end
