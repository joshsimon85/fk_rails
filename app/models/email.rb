class Email < ActiveRecord::Base
  has_rich_text :message
  
  validates_presence_of :full_name, :email
end
