FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now }
    
    after(:create) do |user|
      create_list(:post, 5, user: user)
      user.profile = '自己紹介文'
    end
  end
  
  
  factory :admin, class: User do
    name { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now}
  
    after(:create) do
      create(:post, 5)
    end
  end
  
  factory :new_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { 'password' }
    activated { false }
    activated_at { nil }
  end
end