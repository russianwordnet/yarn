class Word < ActiveRecord::Base
  self.table_name = 'current_words'

  attr_accessible :word, :grammar, :accents, :uris

  has_many :old_words, :order => :revision,
    :inverse_of => :origin

  def update_from(new_word)
    Word.transaction do
      old_word = OldWord.from_word(self)
      old_word.save!

      self.word = new_word.word
      self.grammar = new_word.grammar
      self.accents = new_word.accents
      self.uris = new_word.uris
      self.author_id = new_word.author_id
      self.revision += 1

      save
    end
  end
end
