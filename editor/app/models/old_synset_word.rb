class OldSynsetWord < ActiveRecord::Base
  self.table_name = 'synset_words'

  attr_accessible :word, :nsg, :marks_ids, :samples

  belongs_to :word

  belongs_to :author, class_name: 'User'

  include YarnHistory::History
end
