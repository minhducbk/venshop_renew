class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def convert_to_array_of_hash
    cart_items.map do |cart_item|
      {
        item: cart_item.item,
        quantity: cart_item.quantity.to_i
      }
    end
  end
end
