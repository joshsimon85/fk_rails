module Paginationable
  extend ActiveSupport::Concern

  included do
    def self.limit_and_sort(offset, order, filter=nil, limit=10)
      if filter
        self.where(filter).offset(offset).order(order)
      else
        self.limit(limit).offset(offset).order(order)
      end
    end
  end
end
