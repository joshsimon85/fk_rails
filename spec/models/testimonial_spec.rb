require 'rails_helper'

RSpec.describe Testimonial do
  it { should belong_to :user }
end
