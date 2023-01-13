FactoryBot.define do
  factory :user do
    username { 'sakana太郎' }
    email { Faker::Internet.free_email }
    password { 'sakana1111' }
    password_confirmation { password }
  end
end
