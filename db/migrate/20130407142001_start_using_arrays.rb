class StartUsingArrays < ActiveRecord::Migration
  def change
    change_table :current_words do |t|
      t.remove :accents
      t.remove :uris
      t.integer :accents, array: true, default: []
      t.string :uris, array: true, default: []
      t.index :accents
      t.index :uris
    end

    change_table :words do |t|
      t.remove :accents
      t.remove :uris
      t.integer :accents, array: true, default: []
      t.string :uris, array: true, default: []
      t.index :accents
      t.index :uris
    end

    change_table :current_synsets do |t|
      t.remove :words
      t.remove :definitions
      t.integer :words_ids, array: true, default: []
      t.integer :definitions_ids, array: true, default: []
      t.index :words_ids
      t.index :definitions_ids
    end

    change_table :synsets do |t|
      t.remove :words
      t.remove :definitions
      t.integer :words_ids, array: true, default: []
      t.integer :definitions_ids, array: true, default: []
      t.index :words_ids
      t.index :definitions_ids
    end
  end
end
