class AntonomyRelation < ActiveRecord::Base
  self.table_name = 'current_antonomy_relations'

  belongs_to :author, class_name: 'User'
  has_many :old_relations, class_name: 'OldAntonomyRelation',
    :order => :revision, :inverse_of => :origin
end
