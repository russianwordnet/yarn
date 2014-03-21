class RawSynonym < ActiveRecord::Base
  belongs_to :synonymy, :foreign_key => :raw_synonymy_id, class_name: 'RawSynonymy'
  belongs_to :word1, class_name: 'Word'
  belongs_to :word2, class_name: 'Word'
end
