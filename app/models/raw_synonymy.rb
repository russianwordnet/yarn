class RawSynonymy < ActiveRecord::Base
  belongs_to :word1, class_name: 'Word', :dependent => :destroy
  belongs_to :word2, class_name: 'Word', :dependent => :destroy
  belongs_to :author, class_name: 'User'

  attr_accessible :word1, :word2
end
