class SubsumptionAnswer < ActiveRecord::Base
  attr_accessible :assignment, :assignment_id, :answer

  belongs_to :assignment, class_name: 'SubsumptionAssignment'
  belongs_to :user

  validates_uniqueness_of :assignment, :scope => :user
  validates_inclusion_of :answer, in: %w(yes no report), allow_nil: true
end
