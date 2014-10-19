class CreateCurrentSynsetInterlinks < ActiveRecord::Migration
  def change
    create_table :current_synset_interlinks do |t|
      t.integer :synset_id, null: false
      t.text :source, null: false
      t.text :foreign_id
      t.integer :author_id, null: false
      t.integer :revision, default: 1, null: false
      t.integer :approver_id
      t.timestamp :approved_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end

    change_table :current_synset_interlinks do |t|
      t.index :synset_id
      t.index :source
      t.index :foreign_id
      t.index :author_id
      t.index :revision
      t.index :approver_id
      t.index :approved_at
      t.index :updated_at
      t.index :deleted_at

      t.foreign_key :current_synsets,
        :column => :synset_id,
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
