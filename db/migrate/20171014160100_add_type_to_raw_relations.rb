class AddTypeToRawRelations < ActiveRecord::Migration
  def change
    change_table :raw_relations do |t|
      t.text :type
      t.index :type
    end
  end
end
