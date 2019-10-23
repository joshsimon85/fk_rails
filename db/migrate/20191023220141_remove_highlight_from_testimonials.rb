class RemoveHighlightFromTestimonials < ActiveRecord::Migration[6.0]
  def change
    remove_column :testimonials, :highlight
  end
end
