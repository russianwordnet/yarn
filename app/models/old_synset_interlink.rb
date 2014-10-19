class OldSynsetInterlink < ActiveRecord::Base
  self.table_name = 'synset_interlinks'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'SynsetInterlink',
    foreign_key: 'synset_interlink_id', :inverse_of => :old_relations
end
