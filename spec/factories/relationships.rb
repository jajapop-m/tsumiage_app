FactoryBot.define do
  factory :relationship do
    following { 1 }
    followed { 2 }
  end
end
