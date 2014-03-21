class CreateSynsetWords < ActiveRecord::Migration
  def change
    create_table :synset_words do |t|
      t.integer :author_id
      t.integer :approver_id
      t.timestamp :approved_at
      t.integer :revision, null: false, default: 1

      t.integer :word_id, null: false
      t.boolean :nsg
      t.string :marks, array: true, default: []
      t.integer :samples_ids, array: true, default: []

      t.integer :synset_word_id, null: false
      t.timestamp :created_at
      t.timestamp :deleted_at
    end

    change_table :synset_words do |t|
      t.index :author_id
      t.index :approver_id
      t.index :approved_at
      t.index :revision

      t.index :word_id
      t.index :nsg
      t.index :marks
      t.index :samples_ids

      t.index :synset_word_id
      t.index :created_at
      t.index :deleted_at

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
      t.foreign_key :users,
        :column => :approver_id,
        :dependent => :delete
      t.foreign_key :current_words,
        :column => :word_id,
        :dependent => :delete
      t.foreign_key :current_synset_words,
        :column => :synset_word_id,
        :dependent => :delete
    end
  end
end
