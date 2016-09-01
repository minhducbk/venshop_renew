class User < ActiveRecord::Base
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
end
