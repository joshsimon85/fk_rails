class Testimonial < ApplicationRecord
  include Paginationable

  belongs_to :user
  has_rich_text :message
  has_rich_text :highlight

  validates_presence_of :message
  validates_presence_of :user_id
  validates :highlight, :presence => true, on: :update
  validates :created_by, :presence => true, on: :update
  validate :highlight_length

  private

  def highlight_length
    html_string = self.highlight.body.to_s
    text = ActionView::Base.full_sanitizer.sanitize(html_string).strip
    unless text.length <= 150
      errors.add(:highlight, 'must not be longer than 150 characters')
    end
  end
end
