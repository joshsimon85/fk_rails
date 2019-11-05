class Report < ApplicationRecord
  include Paginationable
  
  validates_presence_of :error_type, :process, :message
end
