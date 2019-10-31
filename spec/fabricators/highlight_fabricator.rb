Fabricator(:highlight) do
  testimonial_id { Faker::Number.number(:digits => 1) }
  highlight      { Faker::Lorem.words(:number => 4).join(' ') }
end
