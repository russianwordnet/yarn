class SynsetInterlink < ActiveRecord::Base
  self.table_name = 'current_synset_interlinks'

  attr_accessible :synset, :source, :foreign_id

  belongs_to :author, class_name: 'User'
  belongs_to :synset

  has_many :old_interlanguage_relations, -> { order(:revision) },
    :inverse_of => :origin
end
