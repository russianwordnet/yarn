class SubsumptionAnswer < ActiveRecord::Base
  attr_accessible :raw_subsumption, :answer

  belongs_to :raw_subsumption
  belongs_to :user

  validates_inclusion_of :answer, in: %w(yes no report), allow_nil: true
end
