class RawDefinition < ActiveRecord::Base
  belongs_to :word, :dependent => :destroy
  belongs_to :definition, :dependent => :destroy
  belongs_to :author, class_name: 'User'

  has_many :raw_examples

  attr_accessible :word, :definition
end
