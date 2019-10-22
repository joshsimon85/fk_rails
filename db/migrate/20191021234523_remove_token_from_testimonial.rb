class RemoveTokenFromTestimonial < ActiveRecord::Migration[6.0]
  def change
    remove_column :testimonials, :token
  end
end
