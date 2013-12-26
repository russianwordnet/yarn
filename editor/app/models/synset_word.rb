class SynsetWord < ActiveRecord::Base
  self.table_name = 'current_synset_words'

  attr_accessible :word, :samples_ids, :nsg, :marks_ids

  belongs_to :author, class_name: 'User'

  belongs_to :word, :inverse_of => :synset_words

  has_many :old_synset_words, :order => :revision,
    :inverse_of => :origin

  has_many :synsets, finder_sql: proc {
    %Q{SELECT * FROM current_synsets WHERE words_ids @> '{#{id}}';} }

  has_many :samples, finder_sql: proc {
    %Q{SELECT * FROM current_samples WHERE id IN
        (SELECT unnest(samples_ids) FROM current_synset_words
          WHERE id = #{id});} }

  has_many :marks, finder_sql: proc {
    %Q{SELECT * FROM marks WHERE id IN
        (SELECT unnest(marks_ids) FROM current_synset_words
          WHERE id = #{id});} }

  def update_from(new_synset_word, save_method = :save)
    SynsetWord.transaction do
      old_synset_words.last and
      old_synset_words.last.created_at > 12.hours.ago and
      old_synset_words.last.author_id == new_synset_word.author_id or
      OldSynsetWord.from_synset_word(self).save!

      self.word_id = new_synset_word.word_id
      self.nsg = new_synset_word.nsg
      self.marks = new_synset_word.marks
      self.samples_ids = new_synset_word.samples_ids
      self.author_id = new_synset_word.author_id
      self.revision += 1

      method(save_method).call.tap { |result| self.reload if result }
    end
  end
end
