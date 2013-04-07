class AddRevisionToCurrentWords < ActiveRecord::Migration
  def change
    change_table :current_words do |t|
      t.integer :revision, default: 1
      t.index :revision
    end
  end
end
