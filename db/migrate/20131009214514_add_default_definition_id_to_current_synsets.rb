class AddDefaultDefinitionIdToCurrentSynsets < ActiveRecord::Migration
  def change
    change_table :current_synsets do |t|
      t.integer :default_definition_id
      t.index :default_definition_id
      t.foreign_key :current_definitions,
        :column => :default_definition_id
    end
  end
end
