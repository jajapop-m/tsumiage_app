FactoryBot.define do
  factory :relationship do
    following { 1 }
    follower { 1 }
  end
end
