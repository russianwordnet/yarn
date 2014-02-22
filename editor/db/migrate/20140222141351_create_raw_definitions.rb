class CreateRawDefinitions < ActiveRecord::Migration
  def change
    create_table :raw_definitions do |t|
      t.belongs_to :word, null: false
      t.belongs_to :definition, null: false
      t.belongs_to :author
      t.timestamps
    end

    change_table :raw_definitions do |t|
      t.index :word_id
      t.foreign_key :current_words, :column => :word_id, :dependent => :delete

      t.index :definition_id
      t.foreign_key :current_definitions, :column => :definition_id, :dependent => :delete

      t.index :author_id
      t.foreign_key :users, :column => :author_id, :dependent => :delete
    end
  end
end
