class WordRelation < ActiveRecord::Base
  self.table_name = 'current_word_relations'

  belongs_to :author, class_name: 'User'
  belongs_to :word1, class_name: 'Word'
  belongs_to :word2, class_name: 'Word'

  has_many :old_relations, class_name: 'OldWordRelation',
    :order => :revision, :inverse_of => :origin
end
