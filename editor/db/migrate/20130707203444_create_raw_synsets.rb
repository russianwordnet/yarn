class CreateRawSynsets < ActiveRecord::Migration
  def change
    create_table :raw_synsets do |t|
      t.integer :words_ids, array: true, default: [], null: false
      t.integer :definitions_ids, array: true, default: [], null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    change_table :raw_synsets do |t|
      t.index :words_ids
      t.index :definitions_ids
      t.index :author_id

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
    end
  end
end
