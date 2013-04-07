class Synset < ActiveRecord::Base
  self.table_name = 'current_synsets'

  attr_accessible :words_ids, :definitions_ids

  has_many :old_synsets, :order => :revision,
    :inverse_of => :origin

  has_many :definitions, :inverse_of => :synsets, finder_sql: proc {
    %Q{SELECT * FROM current_definitions WHERE id IN
        (SELECT unnest(definitions_ids) FROM current_synsets
          WHERE id = #{id});} }

  has_many :words, :inverse_of => :synsets, finder_sql: proc {
    %Q{SELECT * FROM current_synset_words WHERE id IN
        (SELECT unnest(words_ids) FROM current_synsets
          WHERE id = #{id});} }, class_name: 'SynsetWord'

  def update_from(new_synset)
    Synset.transaction do
      old_synset = OldSynset.from_synset(self)
      old_synset.save!

      self.words_ids = new_synset.words_ids
      self.definitions_ids = new_synset.definitions_ids
      self.author_id = new_synset.author_id
      self.revision += 1

      save
    end
  end
end
