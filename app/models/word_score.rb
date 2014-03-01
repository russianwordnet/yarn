class WordScore < ActiveRecord::Base
  self.table_name = 'current_words_scores'

  belongs_to :word
end
