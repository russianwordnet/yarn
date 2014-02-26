class CreateRawSynonymies < ActiveRecord::Migration
  def change
    create_table :raw_synonymies do |t|
      t.belongs_to :word1, null: false
      t.belongs_to :word2, null: false
      t.belongs_to :author
      t.timestamps
    end

    change_table :raw_synonymies do |t|
      t.index :word1_id
      t.foreign_key :current_words, :column => :word1_id, :dependent => :delete

      t.index :word2_id
      t.foreign_key :current_words, :column => :word2_id, :dependent => :delete

      t.index [:word1_id, :word2_id], unique: true

      t.index :author_id
      t.foreign_key :users, :column => :author_id, :dependent => :delete
    end

    execute 'ALTER TABLE raw_synonymies ADD CONSTRAINT raw_synonymies_words_order CHECK (word1_id < word2_id);'
  end
end
