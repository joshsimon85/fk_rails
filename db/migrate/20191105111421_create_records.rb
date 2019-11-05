class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.string :type, :process
      t.text :message
      t.timestamps
    end
  end
end
