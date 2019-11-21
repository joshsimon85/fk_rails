module Searchable
  extend ActiveSupport::Concern

  included do

    private

    def self.query_by_term(search_term)
      if search_term.present?
        search_term.downcase!
        self.where("lower(full_name) LIKE ? OR lower(email) LIKE ?",
                   "%#{search_term}%", "%#{search_term}%")
            .to_a
      else
        []
      end
    end
  end
end
