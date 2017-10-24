class RelationAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :raw_relation
end
