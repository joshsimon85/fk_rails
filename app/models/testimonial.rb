class Testimonial < ApplicationRecord
  include Paginationable

  has_one :highlight
  has_rich_text :message

  validates_presence_of :message
  validates_presence_of :creator
  validates_presence_of :creator_email
  validates_presence_of :creator_avatar_url
end
