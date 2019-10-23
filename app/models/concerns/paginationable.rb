module Paginationable
  extend ActiveSupport::Concern

  included do
    def self.limit_and_sort(offset, order, filter=:all, limit=10)
      if filter == :all
        self.limit(limit).offset(offset).order(:created_at => order)
      else
        self.where(filter).offset(offset).order(:created_at => order)
      end
    end 
  end
end
