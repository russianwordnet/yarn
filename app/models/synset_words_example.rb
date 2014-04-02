class SynsetWordsExample < ActiveRecord::Base
  self.table_name = 'current_synset_words_examples'

  belongs_to :synset_word
  belongs_to :example
end
