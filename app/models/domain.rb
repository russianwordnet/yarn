class Domain < ActiveRecord::Base
  attr_accessible :name, :author_id

  has_many :synset_domains
  has_many :synsets, :through => :synset_domains
  belongs_to :author, class_name: 'User'

  validates :name, presence: true, uniqueness: true
  validates :author, presence: true
end
