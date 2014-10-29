class RawSubsumption < ActiveRecord::Base
  attr_accessible :hypernym, :hyponym, :source

  belongs_to :hypernym, class_name: 'Word'
  belongs_to :hyponym, class_name: 'Word'
  has_many :subsumption_answers
  has_one :score, class_name: 'RawSubsumptionScore'

  validates :hypernym, presence: true
  validates :hyponym, presence: true
  validates_uniqueness_of :hypernym_id, :scope => :hyponym_id
end
