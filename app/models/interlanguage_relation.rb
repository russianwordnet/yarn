class InterlanguageRelation < ActiveRecord::Base
  self.table_name = 'current_interlanguage_relations'

  belongs_to :author, class_name: 'User'
  has_many :old_interlanguage_relations, :order => :revision,
    :inverse_of => :origin
end
