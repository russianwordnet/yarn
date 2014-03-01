class BringTheInterlanguageRelationsIndexesBackHome < ActiveRecord::Migration
  def up
    execute 'ALTER INDEX current_interlinks_pkey RENAME TO current_interlanguage_relations_pkey'
    execute 'ALTER INDEX interlinks_pkey RENAME TO interlanguage_relations_pkey'

    rename_column :interlanguage_relations, :interlink_id, :interlanguage_relation_id
    add_index :interlanguage_relations, :interlanguage_relation_id
    add_foreign_key :interlanguage_relations, :current_interlanguage_relations,
      :column => :interlanguage_relation_id,
      :dependent => :delete

    %w(current_interlanguage_relations interlanguage_relations).each do |table_name|
      add_index table_name, :author_id
      add_index table_name, :approver_id
      add_index table_name, :approved_at
      add_index table_name, :revision

      add_index table_name, :synset_id
      add_index table_name, :pwn

      add_index table_name, :deleted_at

      add_foreign_key table_name, :users,
        :column => :approver_id,
        :dependent => :delete

      add_foreign_key table_name, :users,
        :column => :author_id,
        :dependent => :delete
    end

    add_index :current_interlanguage_relations, :updated_at

    rename_column :interlanguage_relations, :updated_at, :created_at
    add_index :interlanguage_relations, :created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'No.'
  end
end
