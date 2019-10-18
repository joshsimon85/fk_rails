class AddHighlighToTestimonials < ActiveRecord::Migration[6.0]
  def change
    add_column :testimonials, :highlight, :text
  end
end
