FactoryGirl.define do
  factory :event do
    user
    sequence(:start_time) { |n| Time.current }
    sequence(:end_time) { |n| Time.current + 2.seconds }
  end
end
