class Testimonial < ApplicationRecord
  include Paginationable

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_one :highlight
  has_rich_text :message

  validates_presence_of :message
  validates_presence_of :user_id
  validates_presence_of :created_by
end
