module OrderConcern
  extend ActiveSupport::Concern

  def after_cancel(order)
    order.order_items.each do |order_item|
      item = Item.find_by(id: order_item.item_id)
      item.update_columns(stock: (item.stock + order_item.quantity.to_i))
    end
  end

  def satisfy_convert_to_new_status?(order)
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
