class Interlink < ActiveRecord::Base
  self.table_name = 'current_interlinks'

  belongs_to :author, class_name: 'User'
  has_many :old_interlinks, :order => :revision, :inverse_of => :origin
end
