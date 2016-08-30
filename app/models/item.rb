class Item < ActiveRecord::Base
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
end
