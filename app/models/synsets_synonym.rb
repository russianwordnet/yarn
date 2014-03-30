class SynsetsSynonym < ActiveRecord::Base
  self.table_name = 'current_synsets_synonyms'

  belongs_to :synset_word
  belongs_to :synset
end
