class SubsumptionAnswer < ActiveRecord::Base
  attr_accessible :assignment, :answer

  belongs_to :assignment, class_name: 'SubsumptionAssignment'
  belongs_to :user

  validates_inclusion_of :answer, in: %w(yes no report), allow_nil: true
end
