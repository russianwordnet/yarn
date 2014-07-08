class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name, null: false
      t.belongs_to :author, null: false
      t.timestamps
    end

    change_table :domains do |t|
      t.index :name, unique: true
      t.index :author_id
      t.foreign_key :users, :column => :author_id, :dependent => :delete
    end
  end
end
