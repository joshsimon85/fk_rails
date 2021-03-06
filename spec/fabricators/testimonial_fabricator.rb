Fabricator(:testimonial) do
  message { Faker::Lorem.paragraphs(number: 2).join(',') }
  created_at { Time.now }
  creator { Faker::Name.first_name }
  creator_avatar_url { 'abcdefg' }
  creator_email { Faker::Internet.email }
  published { Faker::Boolean.boolean }
end
