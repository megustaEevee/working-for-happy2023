class User < ApplicationRecord
  has_many :works
  has_many :wages
  has_many :comments

  with_options presence: true do
    validates :username
    validates :email
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
