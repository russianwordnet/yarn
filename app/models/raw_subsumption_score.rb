class RawSubsumptionScore < ActiveRecord::Base
  self.table_name = 'raw_subsumptions_scores'

  belongs_to :raw_subsumption
end
