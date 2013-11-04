class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :mark_category_id, null: false
      t.timestamps
    end

    change_table :marks do |t|
      t.index :name, unique: true
      t.index :mark_category_id
      t.foreign_key :mark_categories, :dependent => :delete
    end
  end
end
