class SubsumptionAssignment < ActiveRecord::Base
  attr_accessible :raw_subsumption, :answer

  belongs_to :raw_subsumption
  belongs_to :hypernym_synset, class_name: 'Synset'
  belongs_to :hyponym_synset, class_name: 'Synset'
  has_many :answers, :foreign_key => :assignment_id,
    class_name: 'SubsumptionAnswer'
end
