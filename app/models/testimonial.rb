class Testimonial < ApplicationRecord
  include Paginationable

  has_one :highlight
  has_rich_text :message

  validates_presence_of :message
  validates_presence_of :creator
  validates_presence_of :creator_email
  validates_presence_of :creator_avatar_url

  private

  def self.query_by_term(search_term)
    if search_term.present?
      search_term.downcase!
      Testimonial.where("lower(creator_email) LIKE ? OR lower(creator) LIKE ?",
                        "%#{search_term}%", "%#{search_term}%")
                 .to_a
    else
      []
    end 
  end
end
