class OldInterlanguageRelation < ActiveRecord::Base
  self.table_name = 'interlanguage_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'InterlanguageRelation',
    foreign_key: 'interlink_id', :inverse_of => :old_interlanguage_relations
end
