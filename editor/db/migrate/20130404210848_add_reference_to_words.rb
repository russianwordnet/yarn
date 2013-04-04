class AddReferenceToWords < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.belongs_to :word, null: false
      t.index :word_id
      t.foreign_key :current_words, :column => :word_id, :dependent => :delete
    end
  end
end
