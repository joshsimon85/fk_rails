require 'rails_helper'

RSpec.describe Highlight do
  it { should belong_to :testimonial }
  it { should validate_presence_of :testimonial_id }
  it { should validate_presence_of :highlight }
end
