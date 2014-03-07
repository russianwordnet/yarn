class OldSynsetWord < ActiveRecord::Base
  self.table_name = 'synset_words'

  attr_accessible :word, :nsg, :marks_ids, :examples

  belongs_to :word

  belongs_to :author, class_name: 'User'

  include Yarn::Trackable::History
end
