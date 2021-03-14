FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "John#{n}" }
  end
end
