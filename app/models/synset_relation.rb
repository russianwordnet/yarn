class SynsetRelation < ActiveRecord::Base
  self.table_name = 'current_synset_relations'

  include Yarn::Trackable::Head

  TYPES = %w[hypernymy holonymy antonymy]

  belongs_to :author, class_name: 'User'
  belongs_to :synset1, class_name: 'Synset'
  belongs_to :synset2, class_name: 'Synset'

  validates :relation_type,
    inclusion: {in: TYPES},
    allow_blank: true
end
