class Word < ActiveRecord::Base
  attr_accessible :word, :grammar, :accents, :uris

  serialize :accents, JSON
  serialize :uris, JSON
end
