class OldSynsetRelation < ActiveRecord::Base
  self.table_name = 'synset_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'SynsetRelation',
    foreign_key: 'synset_relation_id', :inverse_of => :old_relations
end
