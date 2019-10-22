class Testimonial < ApplicationRecord
  belongs_to :user
  has_rich_text :message

  validates_presence_of :message
  validates_presence_of :user_id
end
