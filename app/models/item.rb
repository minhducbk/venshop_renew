class Item < ActiveRecord::Base
  attr_accessor :picture
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  mount_uploader :picture, PictureUploader,
                 cloudinary_credentials:
                  Proc.new { |a| a.instance.cloudinary_credentials }
  validates :name, presence: true
  validates :price, presence: true
  validates :stock, presence: true
  validates :description, presence: true
  validates :picture, presence: true

  def cloudinary_credentials
    {
      cloud_name: ENV['cloud_name'],
      api_key: ENV['api_key'],
      api_secret: ENV['api_secret']
    }
  end

  validate :picture_size_validation

  # ... ...
  private

  def picture_size_validation
    errors[:picture] << "should be less than 5MB" if picture.size > 5.megabytes
  end
end
