class SynsetRelation < ActiveRecord::Base
  self.table_name = 'current_synset_relations'

  belongs_to :author, class_name: 'User'
  has_many :old_relations, class_name: 'OldSynsetRelation',
    :order => :revision, :inverse_of => :origin
end
