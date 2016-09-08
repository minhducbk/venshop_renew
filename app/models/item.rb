class Item < ActiveRecord::Base
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_attached_file :image,:storage => :s3,
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
    styles: { medium: "300x300>", thumb: "100x100>" }, dependent: :destroy
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :image, attachment_presence: true
  validates :name, :presence => true
  validates :price, :presence => true
  validates :stock, :presence => true
  validates :description, :presence => true

  def s3_credentials
    { :access_key_id => ENV['aws_access_key_id'], :secret_access_key => ENV['aws_secret_access_key']}
  end
end
