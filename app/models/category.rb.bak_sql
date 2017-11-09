class Category < ActiveRecord::Base
  has_many :items, dependent: :destroy
  validates :name, uniqueness: :true
end
