FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "test#{n}@example.com"}
    password { 'password' }
    
    after(:create) do |user|
      create_list(:post, 5, user: user)
    end
  end
end