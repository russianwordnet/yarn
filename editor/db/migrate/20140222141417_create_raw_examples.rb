class CreateRawExamples < ActiveRecord::Migration
  def change
    create_table :raw_examples do |t|
      t.belongs_to :raw_definition, null: false
      t.belongs_to :sample, null: false
      t.belongs_to :author
      t.timestamps
    end

    change_table :raw_examples do |t|
      t.index :raw_definition_id
      t.foreign_key :raw_definitions, :column => :raw_definition_id, :dependent => :delete

      t.index :sample_id
      t.foreign_key :current_samples, :column => :sample_id, :dependent => :delete

      t.index :author_id
      t.foreign_key :users, :column => :author_id, :dependent => :delete
    end
  end
end
