class CreateTestimonials < ActiveRecord::Migration[6.0]
  def change
    create_table :testimonials do |t|
      t.string :full_name, :email, :token
      t.integer :user_id
      t.timestamps
    end
  end
end
