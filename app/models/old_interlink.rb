class OldInterlink < ActiveRecord::Base
  self.table_name = 'interlinks'

  belongs_to :author, class_name: 'User'
  belongs_to :origin, class_name: 'Interlink',
    foreign_key: 'interlink_id', :inverse_of => :old_interlinks
end
