class Email < ActiveRecord::Base
  has_rich_text :message

  validates_presence_of :full_name, :email, :message
  validates :email, format: { with: /@/ }

  def self.limit_and_sort_emails(offset, order, limit=10)
    self.limit(limit).offset(offset).order(:created_at => order)
  end
end
