class Order < ActiveRecord::Base
  has_many :order_items, dependent: :destroy
  belongs_to :user
  enum order_status: {
    New: 0,
    Prepare: 1,
    Shipping: 2,
    Done: 3,
    Cancel: 4,
    new_group: [0, 1, 2 , 3],
    cancel_group: [4]
  }

  def after_cancel
    order_items.each do |order_item|
      item = order_item.item
      item.update_columns(stock: (item.stock + order_item.quantity.to_i))
    end
  end

  def satisfy_convert_to_new_group?
    order_items.each do |order_item|
      item = order_item.item
      return false if item.stock < order_item.quantity.to_i
    end
    order_items.each do |order_item|
      item = order_item.item
      item.update_columns(stock: (item.stock - order_item.quantity.to_i))
    end
    true
  end

  def convert_to_array_of_hash
    order_items.map do |order_item|
      {
        item: order_item.item,
        quantity: order_item.quantity.to_i
      }
    end
  end

  def get_quantity
    order_items.inject(0) do |quantity, order_item|
      quantity + order_item.quantity.to_i
    end
  end

  def get_name_products
    quantity = get_quantity
    first_item = Item.find_by(id: order_items[0].item_id)
    prefix = (order_items[0].quantity.to_i == 1) ?
      "#{first_item.name}" : "#{order_items[0].quantity} #{first_item.name}"
    if order_items.count == 1
      prefix
    else
      "#{prefix} and #{quantity - order_items[0].quantity.to_i} other products"
    end
  end
end
