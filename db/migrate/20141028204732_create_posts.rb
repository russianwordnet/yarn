class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :body, null: false
      t.text :slug
      t.integer :author_id, null: false
      t.timestamps
    end

    change_table :posts do |t|
      t.index :slug
      t.index :author_id

      t.foreign_key :users,
        :column => :author_id,
        :dependent => :delete
    end
  end
end
