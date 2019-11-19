class RemameColumnCreatedByToCreatorInTestimonials < ActiveRecord::Migration[6.0]
  def change
    rename_column :testimonials, :created_by, :creator
  end
end
