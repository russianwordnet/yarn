class Synset < ActiveRecord::Base
  attr_accessible :words, :definitions, :pwns

  serialize :words, JSON
  serialize :definitions, JSON
  serialize :pwns, JSON
end
