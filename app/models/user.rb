class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  enum role_user: {
    admin: 0,
    customer: 1
  }
end
