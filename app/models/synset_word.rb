class SynsetWord < ActiveRecord::Base
  self.table_name = 'current_synset_words'

  include Yarn::Trackable::Head

  attr_accessible :word, :definitions_ids, :examples_ids, :nsg, :marks_ids

  belongs_to :author, class_name: 'User'

  belongs_to :word, :inverse_of => :synset_words

  has_and_belongs_to_many :synsets,
    join_table: 'current_synsets_synonyms'

  has_many :synsets_synonyms
  has_many :synsets, through: :synsets_synonyms

  has_many :synset_words_definitions
  has_many :definitions, through: :synset_words_definitions

  has_many :synset_words_examples
  has_many :samples, :through => :synset_words_examples, :source => :example

  has_many :examples, :through => :synset_words_examples

  has_many :synset_words_marks
  has_many :marks, :through => :synset_words_marks


private
  def definition_ids
    raise 'Use #definitions_ids instead'
  end
end
