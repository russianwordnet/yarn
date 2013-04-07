class SynsetWord < ActiveRecord::Base
  self.table_name = 'current_synset_words'

  attr_accessible :word, :nsg, :marks, :samples

  belongs_to :word

  has_many :old_synset_words, :order => :revision,
    :inverse_of => :origin

  has_many :synsets, :inverse_of => :words, finder_sql: proc {
    %Q{SELECT * FROM current_synsets WHERE words_ids @> '{#{id}}';} }

  def update_from(new_synset_word)
    SynsetWord.transaction do
      old_synset_word = OldSynsetWord.from_synset_word(self)
      old_synset_word.save!

      self.word = new_synset_word.word
      self.nsg = new_synset_word.nsg
      self.marks = new_synset_word.marks
      self.samples_ids = new_synset_word.samples_ids
      self.author_id = new_synset_word.author_id
      self.revision += 1

      save
    end
  end
end
