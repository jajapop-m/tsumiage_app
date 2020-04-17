FactoryBot.define do
  trait :picture_build do
   picture { File.new("#{Rails.root}/spec/fixtures/picture.jpg") }
  end

  factory :post do
    sequence(:title) { |n| "テストタイトル-#{n}" }
    sequence(:content) { |n| "ここに本文が入リます。テスト-#{n}" }
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    user
  end
end
