class OldAntonomyRelation < ActiveRecord::Base
  self.table_name = 'antonomy_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'AntonomyRelation',
    foreign_key: 'antonomy_relation_id', :inverse_of => :old_relations
end
