class Category
  include Mongoid::Document	
  include Mongoid::Timestamps

  field :id, type: Integer
  field :name, type: String
  field :keyword, type: String

  has_many :items, dependent: :destroy
  validates :name, uniqueness: :true
end
