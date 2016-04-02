FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User_#{n}"}
    sequence(:device_token) { |n| "Token_#{n}"}
  end
end
