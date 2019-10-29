class CreateHighlights < ActiveRecord::Migration[6.0]
  def change
    create_table :highlights do |t|
      t.integer :testimonial_id
      t.timestamps
    end
  end
end
