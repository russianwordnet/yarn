class RawRelation < ActiveRecord::Base
  self.inheritance_column = :foo

  belongs_to :upper, class_name: 'Word'
  belongs_to :lower, class_name: 'Word'

  has_one :score, class_name: 'RawSubsumptionScore',
    inverse_of: :raw_subsumption,
    foreign_key: :raw_subsumption_id

  has_many :relation_assignments

  validates :upper, presence: true
  validates :lower, presence: true
  validates_uniqueness_of :upper_id, :scope => :lower_id
end
