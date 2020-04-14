FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "テストタイトル-#{n}" }
    sequence(:content) { |n| "ここに本文が入リます。テスト-#{n}" }
    picture { "MyString" }
    user
  end
end
