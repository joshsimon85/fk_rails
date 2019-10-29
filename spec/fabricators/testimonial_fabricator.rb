Fabricator(:testimonial) do
  user_id { Faker::Number.number({ :digits => 1 }) }
  created_at { Time.now }
  published { Faker::Boolean.boolean }
end
