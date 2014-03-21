class RawDefinition < ActiveRecord::Base
  belongs_to :word, :dependent => :destroy
  belongs_to :definition, :dependent => :destroy
  belongs_to :author, class_name: 'User'

  attr_accessible :word, :definition
end
