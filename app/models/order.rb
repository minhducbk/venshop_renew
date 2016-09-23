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
    self.order_items.each do |order_item|
      item = order_item.item
      item.update_columns(stock: (item.stock + order_item.quantity.to_i))
    end
  end

  def satisfy_convert_to_new_group?
    self.order_items.each do |order_item|
      item = order_item.item
      return false if item.stock < order_item.quantity.to_i
    end
    self.order_items.each do |order_item|
      item = order_item.item
      item.update_columns(stock: (item.stock - order_item.quantity.to_i))
    end
    true
  end

  def convert_to_array_of_hash
    self.order_items.map do |order_item|
      {
        item: order_item.item,
        quantity: order_item.quantity.to_i
      }
    end
  end

  def get_quantity
    self.order_items.inject(0) do |quantity, order_item|
      quantity + order_item.quantity.to_i
    end
  end

  def get_name_products
    quantity = self.get_quantity
    first_item = Item.find_by(id: self.order_items[0].item_id)
    prefix = (self.order_items[0].quantity.to_i == 1) ?
      "#{first_item.name}" : "#{self.order_items[0].quantity} #{first_item.name}"
    if self.order_items.count == 1
      prefix
    else
      "#{prefix} and #{quantity - self.order_items[0].quantity.to_i} other products"
    end
  end
end
