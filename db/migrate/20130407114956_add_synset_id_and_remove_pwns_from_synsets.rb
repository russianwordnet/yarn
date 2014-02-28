class AddSynsetIdAndRemovePwnsFromSynsets < ActiveRecord::Migration
  def change
    change_table :synsets do |t|
      t.integer :synset_id
      t.index :synset_id
      t.foreign_key :current_synsets, :column => :synset_id,
        :dependent => :delete
      t.remove :pwns
    end
  end
end
