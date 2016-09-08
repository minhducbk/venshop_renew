class Item < ActiveRecord::Base
  attr_accessor :picture
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  # has_attached_file :image, :storage => :cloudinary,
  #   :cloudinary_credentials => Proc.new{|a| a.instance.cloudinary_credentials},
  #   styles: { medium: "300x300>", thumb: "100x100>" }, dependent: :destroy
  mount_uploader :picture, PictureUploader, :cloudinary_credentials => Proc.new{|a| a.instance.cloudinary_credentials}
  # has_attached_file :picture, :storage => :cloudinary,
  #   :cloudinary_credentials => Proc.new{|a| a.instance.cloudinary_credentials}

  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  # validates :image, attachment_presence: true
  validates :name, :presence => true
  validates :price, :presence => true
  validates :stock, :presence => true
  validates :description, :presence => true
  validates :picture, :presence => true

  def cloudinary_credentials
    {
      :cloud_name => ENV['cloud_name'],
      :api_key => ENV['api_key'],
      :api_secret => ENV['api_secret']
    }
  end
end
