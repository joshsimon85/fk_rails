class Testimonial < ApplicationRecord
  include Paginationable

  belongs_to :user
  has_rich_text :message
  has_rich_text :highlight

  validates_presence_of :message
  validates_presence_of :user_id
end
