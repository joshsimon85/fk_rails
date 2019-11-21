class Email < ActiveRecord::Base
  include Paginationable
  include Searchable
  
  has_rich_text :message

  validates_presence_of :full_name, :email, :message
  validates :email, format: { with: /@/ }
end
