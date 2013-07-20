class CreateWordRelations < ActiveRecord::Migration
  def change
    create_table :word_relations do |t|
      t.integer :word_relation_id, null: false
      t.integer :word1_id, null: false
      t.integer :word2_id, null: false
      t.integer :author_id, null: false
      t.integer :revision, default: 1, null: false
      t.integer :approver_id, null: false
      t.timestamp :approved_at
      t.timestamp :created_at
      t.timestamp :deleted_at
    end

    change_table :word_relations do |t|
      t.index :word_relation_id
      t.index :word1_id
      t.index :word2_id
      t.index :author_id
      t.index :revision
      t.index :approver_id
      t.index :approved_at
      t.index :created_at
      t.index :deleted_at

      t.foreign_key :current_word_relations,
        :column => :word_relation_id,
        :dependent => :delete

      t.foreign_key :current_words,
        :column => :word1_id,
        :dependent => :delete

      t.foreign_key :current_words,
        :column => :word2_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete

      t.foreign_key :users,
        :column => :approver_id,
        :dependent => :delete
    end
  end
end
