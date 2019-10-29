class Highlight < ApplicationRecord
  belongs_to :testimonial

  has_rich_text :highlight

  validates_presence_of :testimonial_id
  validates_presence_of :highlight
  
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
