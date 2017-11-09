class Item < ActiveRecord::Base
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  attr_accessor :picture
  mount_uploader :picture, PictureUploader,
                 cloudinary_credentials:
                  Proc.new { |a| a.instance.cloudinary_credentials }

  validates :name, presence: true
  validates :price, presence: true
  validates :stock, presence: true
  validates :description, presence: true
  validates :picture, presence: true
  validate :picture_size_validation

  paginates_per Settings.entries_per_page

  scope :recommended, -> (limit) { order("updated_at desc").limit(limit) }
  scope :newest, -> (limit) { order("created_at desc").limit(limit) }

  def cloudinary_credentials
    {
      cloud_name: ENV['cloud_name'],
      api_key: ENV['api_key'],
      api_secret: ENV['api_secret']
    }
  end

  private

  def picture_size_validation
    errors[:picture] << "should be less than 5MB" if picture.size > 5.megabytes
  end
end
