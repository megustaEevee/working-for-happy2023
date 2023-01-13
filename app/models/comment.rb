class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :work

  validates :text, presence: true
end
