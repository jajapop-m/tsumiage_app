FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password { 'password' }
    
    after(:create) do |user|
      create_list(:post, 5, user: user)
    end
  end
end