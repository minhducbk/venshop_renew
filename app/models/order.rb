class Order < ActiveRecord::Base
  has_many :order_items, dependent: :destroy
  belongs_to :user
  enum order_status: {
    New: 0,
    Prepare: 1,
    Shipping: 2,
    Done: 3,
    Cancel: 4
  }
end
