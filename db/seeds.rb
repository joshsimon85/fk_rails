jon = User.create(full_name: 'Jon Doe', email: 'jon@doe.com', password: 'password', admin: true, confirmed_at: Time.now)
jane = User.create(full_name: 'Jane Doe', email: 'jane@doe.com', phone_number: '333-333-3333', password: 'password', confirmed_at: Time.now)
user_1 = User.create(full_name: Faker::Name.name, email: 'user1@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')
user_2 = User.create(full_name: Faker::Name.name, email: 'user2@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')


21.times do
  Email.create(full_name: Faker::Name.name, email: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, message: Faker::Lorem.paragraphs(number: 4).join(','))
end

21.times do |n|
  Fabricate(:user, password: 'password')
end

10.times do |n|
  user = User.find(n + 1)
  message = Faker::Lorem.paragraphs(number: 20).join(',')
  testimonial = Testimonial.create(message: message, published: Faker::Boolean.boolean, creator: user.full_name,  creator_email: user.email, creator_avatar_url: user.avatar_url)
  highlight = message.slice(0, 150)
  if (n + 1) < 12
     Highlight.create(testimonial_id: testimonial.id, highlight: highlight)
   end
end

11.times do |n|
  user = User.find(n + 11)
  message = Faker::Lorem.paragraphs(number: 10).join(',')
  testimonial = Testimonial.create(message: message, published: Faker::Boolean.boolean, creator: user.full_name, creator_email: user.email, creator_avatar_url: user.avatar_url)
end

21.times do
  Fabricate(:report)
end
