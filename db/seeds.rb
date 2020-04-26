User.create!(name:  "テストユーザー",
             email: "test@example.com",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now,
             image_name: nil)

99.times do |n|
  name  = Faker::Name.name
  email = "test-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
             activated_at: Time.zone.now,
             image_name: nil)
end
  
users = User.order(:created_at).take(6)
65.times do
  title = Faker::Lorem.sentence(word_count: 5)
  content = Faker::Lorem.sentence(word_count: 20)
  users.each { |user| user.posts.create!(title: title, content: content) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }