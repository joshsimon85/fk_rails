Fabricator(:testimonial) do
  user_id { Faker::Number.number({ :digits => 1 }) }
  message { Faker::Lorem.paragraphs(number: 2).join(',') }
  created_at { Time.now }
  published { Faker::Boolean.boolean }
end
