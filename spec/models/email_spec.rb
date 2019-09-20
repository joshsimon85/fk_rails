require 'rails_helper'

RSpec.describe Email do
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }
end
