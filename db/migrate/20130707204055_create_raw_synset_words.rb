class CreateRawSynsetWords < ActiveRecord::Migration
  def change
    create_table :raw_synset_words do |t|
      t.integer :word_id, null: false
      t.string :nsg
      t.string :marks, array: true, default: [], null: false
      t.integer :samples_ids, array: true, default: [], null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    change_table :raw_synset_words do |t|
      t.index :word_id
      t.index :nsg
      t.index :marks
      t.index :samples_ids
      t.index :author_id

      t.foreign_key :current_words,
        :column => :word_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
    end
  end
end
