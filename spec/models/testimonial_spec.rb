require 'rails_helper'

RSpec.describe Testimonial do
  it { should validate_presence_of :message }
  it { should validate_presence_of :creator }
  it { should validate_presence_of :creator_email }
  it { should validate_presence_of :creator_avatar_url }
  it { should have_one :highlight }
end
