FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now }
    
    after(:create) do |user|
      create_list(:post, 5, user: user)
    end
  end
  
  factory :admin do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now}
  
    after(:create) do
      create(:post, 5)
    end
    
  end
end