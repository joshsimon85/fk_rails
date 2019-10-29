jon = User.create(full_name: 'Jon Doe', email: 'jon@doe.com', password: 'password', admin: true)
jane = User.create(full_name: 'Jane Doe', email: 'jane@doe.com', phone_number: '333-333-3333', password: 'password')
user_1 = User.create(full_name: Faker::Name.name, email: 'user1@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')
user_2 = User.create(full_name: Faker::Name.name, email: 'user2@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')

def format_name(creator)
  name_list = creator.titleize.split(' ')
  "#{name_list[0]} #{name_list[-1].slice(0)}."
end

21.times do
  Email.create(full_name: Faker::Name.name, email: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, message: Faker::Lorem.paragraphs(number: 4).join(','))
end

21.times do |n|
  Fabricate(:user)
end

21.times do |n|
  user = User.find(n + 1)
  message = Faker::Lorem.paragraphs(number: 10).join(',')
  testimonial = Testimonial.create(user_id: n + 1, message: message, published: Faker::Boolean.boolean, created_by: format_name(user.full_name))
  #highlight = message.slice(0, 150)
  # if (n + 1) > 12
  #   Highlight.create(testimonial_id: testimonial.id, highlight: highlight)
  # end
end
