class CreateSynsetDomains < ActiveRecord::Migration
  def change
    create_table :synset_domains do |t|
      t.belongs_to :domain, null: false
      t.belongs_to :synset, null: false
      t.timestamps
    end

    change_table :synset_domains do |t|
      t.index :domain_id
      t.index :synset_id
      t.foreign_key :domains, :dependent => :delete
      t.foreign_key :current_synsets, :column => :synset_id, :dependent => :delete
    end
  end
end
