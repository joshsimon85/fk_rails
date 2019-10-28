class Testimonial < ApplicationRecord
  include Paginationable

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_rich_text :message
  has_rich_text :highlight

  validates_presence_of :message
  validates_presence_of :user_id
  validate :highlight_length

  private

  def highlight_length
    html_string = self.highlight.body.to_s
    text = ActionView::Base.full_sanitizer.sanitize(html_string).strip
    if text.length > 150
      errors.add(:highlight, 'must be less than 151 characters')
    end

    if text.length == 0
      errors.add(:highlight, "can't be blank")
    end
  end
end
