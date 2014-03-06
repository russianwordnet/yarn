class SynsetWord < ActiveRecord::Base
  self.table_name = 'current_synset_words'

  include Yarn::Trackable

  attr_accessible :word, :definitions_ids, :examples_ids, :nsg, :marks_ids

  belongs_to :author, class_name: 'User'

  belongs_to :word, :inverse_of => :synset_words

  has_and_belongs_to_many :synsets,
    join_table: 'current_synsets_synonyms'

  has_and_belongs_to_many :definitions,
    join_table: 'current_synset_words_definitions'

  has_and_belongs_to_many :samples, association_foreign_key: 'example_id',
    join_table: 'current_synset_words_examples', class_name: 'Example'

  has_and_belongs_to_many :examples, association_foreign_key: 'example_id',
    join_table: 'current_synset_words_examples'

  has_and_belongs_to_many :marks,
    join_table: 'current_synset_words_marks'

  # Deprecated
  def update_from(new_synset_word, save_method = :save)
    SynsetWord.transaction do
      old_synset_words.last and
      old_synset_words.last.created_at > 12.hours.ago and
      old_synset_words.last.author_id == new_synset_word.author_id or
      OldSynsetWord.from_synset_word(self).save!

      self.word_id = new_synset_word.word_id
      self.nsg = new_synset_word.nsg
      self.marks = new_synset_word.marks
      self.examples_ids = new_synset_word.examples_ids
      self.author_id = new_synset_word.author_id
      self.revision += 1

      method(save_method).call.tap { |result| self.reload if result }
    end
  end
end
