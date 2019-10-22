class DropFullNameEmailPhoneFromTestimonials < ActiveRecord::Migration[6.0]
  def change
    remove_column :testimonials, :full_name
    remove_column :testimonials, :email
  end
end
