class SynsetWordMark < ActiveRecord::Base
  self.table_name = 'current_synset_words_marks'

  belongs_to :synset_word
  belongs_to :mark
end
