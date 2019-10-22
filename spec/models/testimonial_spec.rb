require 'rails_helper'

RSpec.describe Testimonial do
  it { should belong_to :user }
  it { should validate_presence_of :message }
end
