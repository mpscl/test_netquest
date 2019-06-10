FactoryBot.define do
  factory :user do
    nickname { Faker::Lorem.word }
  end
end