class Item < ActiveRecord::Base
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, dependent: :destroy
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :image, attachment_presence: true
  validates :name, :presence => true
  validates :price, :presence => true
  validates :stock, :presence => true
  validates :description, :presence => true
end
