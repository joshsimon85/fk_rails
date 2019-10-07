class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.string :full_name, :email, :phone_number, :message
      t.timestamps
    end
  end
end
