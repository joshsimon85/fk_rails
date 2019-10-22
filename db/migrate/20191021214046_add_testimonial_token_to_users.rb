class AddTestimonialTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :testimonial_token, :string
  end
end
