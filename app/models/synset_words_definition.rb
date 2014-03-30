class SynsetWordsDefinition < ActiveRecord::Base
  self.table_name = 'current_synset_words_definitions'

  belongs_to :synset_word
  belongs_to :definition
end
