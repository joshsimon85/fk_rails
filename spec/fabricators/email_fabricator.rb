Fabricator(:email) do
  full_name { Faker::Name.name }
  email { Faker::Internet.email }
  message { Faker::Lorem.paragraphs(number: 5).join(', ') }
end
