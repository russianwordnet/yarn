class Synset < ActiveRecord::Base
  self.table_name = 'current_synsets'

  attr_accessible :words, :definitions

  has_many :old_synsets, :order => :revision,
    :inverse_of => :origin

  serialize :words, JSON
  serialize :definitions, JSON

  def update_from(new_synset)
    Synset.transaction do
      old_synset = OldSynset.from_synset(self)
      old_synset.save!

      self.words = new_synset.words
      self.definitions = new_synset.definitions
      self.author_id = new_synset.author_id
      self.revision += 1

      save
    end
  end
end
