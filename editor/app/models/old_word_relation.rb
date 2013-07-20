class OldWordRelation < ActiveRecord::Base
  self.table_name = 'word_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'WordRelation',
    foreign_key: 'word_relation_id', :inverse_of => :old_relations
end
