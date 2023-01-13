class Wage < ApplicationRecord
  belongs_to :user
  belongs_to :work

  with_options presence: true do
    validates :end_time
    validates :paying
  end
end
