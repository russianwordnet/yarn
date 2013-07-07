class CreateRawSamples < ActiveRecord::Migration
  def change
    create_table :raw_samples do |t|
      t.string :text, null: false
      t.string :source
      t.string :uri
      t.integer :author_id, null: false
      t.timestamps
    end

    change_table :raw_samples do |t|
      t.index :source
      t.index :uri
      t.index :author_id

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
    end
  end
end
