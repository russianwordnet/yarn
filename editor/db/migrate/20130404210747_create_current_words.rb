class CreateCurrentWords < ActiveRecord::Migration
  def change
    create_table :current_words do |t|
      t.integer :author_id
      t.integer :approver_id
      t.timestamp :approved_at
      t.timestamp :created_at
      t.string :word, null: false
      t.string :grammar
      t.text :accents
      t.text :uris
      t.timestamp :deleted_at
    end

    change_table :current_words do |t|
      t.index :author_id
      t.index :approver_id
      t.index :approved_at
      t.index :word
      t.index :grammar
      t.index :deleted_at

      t.foreign_key :users, :column => :author_id, :dependent => :delete
      t.foreign_key :users, :column => :approver_id, :dependent => :delete
    end
  end
end
