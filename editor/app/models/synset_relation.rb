class SynsetRelation < ActiveRecord::Base
  self.table_name = 'current_synset_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :synset1, class_name: 'Synset'
  belongs_to :synset2, class_name: 'Synset'

  has_many :old_relations, class_name: 'OldSynsetRelation',
    :order => :revision, :inverse_of => :origin
end
