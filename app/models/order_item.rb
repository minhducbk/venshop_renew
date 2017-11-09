class OrderItem
  include Mongoid::Document 
  include Mongoid::Timestamps

  field :id, type: Integer
  field :order_id, type: Integer
  field :item_id, type: Integer
  field :quantity, type: Integer

  belongs_to :item
  belongs_to :order
end
