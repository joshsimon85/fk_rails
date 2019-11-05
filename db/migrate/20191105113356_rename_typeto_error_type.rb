class RenameTypetoErrorType < ActiveRecord::Migration[6.0]
  def change
    rename_column :records, :type, :error_type
  end
end
