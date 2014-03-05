class NoMoreDefinitionsForYa < ActiveRecord::Migration
  def up
    remove_column :current_synsets, :definitions_ids
    remove_column :synsets, :definitions_ids
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
