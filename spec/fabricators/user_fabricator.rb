Fabricator(:user) do
  full_name              { Faker::Name.name }
  phone_number           { Faker::PhoneNumber.phone_number }
  email                  { Faker::Internet.email }
  password               { Faker::Lorem.characters(number: 10) }
  reset_password_token   { Faker::Lorem.characters(number: 10) }
  reset_password_sent_at { "2019-10-10 07:41:35" }
  remember_created_at    { "2019-10-10 07:41:35" }
  last_sign_in_at        { "2019-10-10 07:41:35" }
  current_sign_in_ip     { Faker::Internet.public_ip_v4_address }
  last_sign_in_ip        { Faker::Internet.public_ip_v4_address }
  created_at             { "2019-10-10 07:41:35" }
  updated_at             { "2019-10-10 07:41:35" }
  admin                  { false }
end
