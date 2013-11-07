class AntonomyRelation < ActiveRecord::Base
  self.table_name = 'current_antonomy_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :synset1, class_name: 'Synset'
  belongs_to :synset2, class_name: 'Synset'
  belongs_to :word1, class_name: 'Word'
  belongs_to :word2, class_name: 'Word'

  has_many :old_relations, class_name: 'OldAntonomyRelation',
    :order => :revision, :inverse_of => :origin
end
