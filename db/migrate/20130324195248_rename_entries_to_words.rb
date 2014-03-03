class RenameEntriesToWords < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.remove :type
      t.remove :updated_at

      t.integer :revision, null: false, default: 1
      t.string :word, null: false
      t.string :grammar
      t.text :accents
      t.text :uris
      t.timestamp :deleted_at

      t.index :revision
      t.index :word, unique: true
      t.index :grammar
      t.index :deleted_at
    end

    rename_table :entries, :words
  end
end
