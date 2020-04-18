FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    
    after(:create) do |user|
      create_list(:post, 5, user: user)
    end
  end
end