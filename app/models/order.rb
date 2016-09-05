class Order < ActiveRecord::Base
  has_many :order_items, dependent: :destroy
  belongs_to :user
  enum order_status: {
    new_order: 0,
    prepare: 1,
    shipping: 2,
    done: 3,
    cancel_refund: 4
  }
end
