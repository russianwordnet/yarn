class RawExample < ActiveRecord::Base
  belongs_to :raw_definition, :dependent => :destroy
  belongs_to :example, class_name: 'Sample', :dependent => :destroy
  belongs_to :author, class_name: 'User'

  attr_accessible :raw_definition, :example
end
