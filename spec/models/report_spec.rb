require 'rails_helper'

RSpec.describe Report do
  it { should validate_presence_of :error_type }
  it { should validate_presence_of :origin }
  it { should validate_presence_of :message }
end
