class SynsetDomain < ActiveRecord::Base
  attr_accessible :domain, :synset

  belongs_to :domain
  belongs_to :synset

  validates :domain, presence: true
  validates :synset, presence: true
end
