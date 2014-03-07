class SynsetWord < ActiveRecord::Base
  self.table_name = 'current_synset_words'

  include Yarn::Trackable::Head

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
end
