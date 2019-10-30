require 'rails_helper'

RSpec.describe Testimonial do
  it { should belong_to :creator }
  it { should validate_presence_of :message }
  it { should validate_presence_of :created_by }
  it { should validate_presence_of :user_id }
  it { should have_one :highlight }
end
