FactoryBot.define do
  trait :picture_build do
   picture { File.new("#{Rails.root}/spec/fixtures/picture.jpg") }
  end

  factory :post do
    sequence(:title) { Faker::Lorem.sentence }
    sequence(:content) { Faker::Lorem.sentence(word_count: 30) }
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    user
  end
end
