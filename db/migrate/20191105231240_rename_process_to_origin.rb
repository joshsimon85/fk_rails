class RenameProcessToOrigin < ActiveRecord::Migration[6.0]
  def change
    rename_column :reports, :process, :origin
  end
end
