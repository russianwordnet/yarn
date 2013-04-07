class Synset < ActiveRecord::Base
  attr_accessible :words, :definitions

  serialize :words, JSON
  serialize :definitions, JSON
end
