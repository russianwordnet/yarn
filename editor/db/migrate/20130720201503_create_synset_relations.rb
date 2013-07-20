class CreateSynsetRelations < ActiveRecord::Migration
  def change
    create_table :synset_relations do |t|
      t.integer :synset_relation_id, null: false
      t.integer :synset1_id, null: false
      t.integer :synset2_id, null: false
      t.integer :author_id, null: false
      t.integer :revision, default: 1, null: false
      t.integer :approver_id, null: false
      t.timestamp :approved_at
      t.timestamp :created_at
      t.timestamp :deleted_at
    end

    change_table :synset_relations do |t|
      t.index :synset_relation_id
      t.index :synset1_id
      t.index :synset2_id
      t.index :author_id
      t.index :revision
      t.index :approver_id
      t.index :approved_at
      t.index :created_at
      t.index :deleted_at

      t.foreign_key :current_synset_relations,
        :column => :synset_relation_id,
        :dependent => :delete

      t.foreign_key :current_synsets,
        :column => :synset1_id,
        :dependent => :delete

      t.foreign_key :current_synsets,
        :column => :synset2_id,
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
