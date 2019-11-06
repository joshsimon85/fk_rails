Fabricator(:report) do
  error_type { %w(ERROR ALERT).sample }
  origin { %w(Emal Testimonial).sample + ' Worker Error' }
  message { "Can not find a record with id='#{(1..20).to_a.sample}'" }
end
