jon = User.create(full_name: 'Jon Doe', email: 'jon@doe.com', password: 'password', admin: true)
jane = User.create(full_name: 'Jane Doe', email: 'jane@doe.com', phone_number: '333-333-3333', password: 'password')
user_1 = User.create(full_name: Faker::Name.name, email: 'user1@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')
user_2 = User.create(full_name: Faker::Name.name, email: 'user2@test.com', phone_number: Faker::PhoneNumber.phone_number, password: 'password')

21.times do
  Email.create(full_name: Faker::Name.name, email: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, message: Faker::Lorem.paragraphs(number: 4).join(','))
end

Testimonial.create(user_id: 1, message: Faker::Lorem.paragraphs(number: 4).join(','))
Testimonial.create(user_id: 2, message: Faker::Lorem.paragraphs(number: 4).join(','), published: true)
