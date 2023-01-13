class Work < ApplicationRecord
  belongs_to :user
  has_one :wage
  has_many :comments

  validates :start_time, presence: true
end
