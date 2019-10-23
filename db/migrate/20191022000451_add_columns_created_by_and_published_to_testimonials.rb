class AddColumnsCreatedByAndPublishedToTestimonials < ActiveRecord::Migration[6.0]
  def change
    add_column :testimonials, :created_by, :string
    add_column :testimonials, :published, :boolean, default: false
  end
end
