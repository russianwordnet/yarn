class SubsumptionAssignment < ActiveRecord::Base
  attr_accessible :raw_subsumption, :hypernym_synset, :hyponym_synset

  belongs_to :raw_subsumption
  belongs_to :hypernym_synset, class_name: 'Synset'
  belongs_to :hyponym_synset, class_name: 'Synset'
  has_many :answers, :foreign_key => :assignment_id,
    class_name: 'SubsumptionAnswer'

  validates :raw_subsumption, presence: true
  validates :hypernym_synset, presence: true
  validates :hyponym_synset, presence: true
  validates_uniqueness_of :hypernym_synset_id, :scope => :hyponym_synset_id

  scope :for_user, ->(user) {
    user_id = user.class == User ? user.id : user
    joins('LEFT OUTER JOIN subsumption_answers ON subsumption_answers.assignment_id = subsumption_assignments.id').
    joins('JOIN raw_subsumptions_scores ON raw_subsumptions_scores.raw_subsumption_id = subsumption_assignments.raw_subsumption_id').
    where(user_id && 'subsumption_answers.user_id <> ? OR subsumption_answers.user_id IS NULL', user_id).
    order('score DESC')
  }
end
