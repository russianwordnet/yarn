class User < ActiveRecord::Base
  devise :omniauthable

  attr_accessible :name, :provider, :uid

  has_many :words, :foreign_key => :author_id
  has_many :synsets, :foreign_key => :author_id
  has_many :synset_words, :foreign_key => :author_id
  has_many :samples, :foreign_key => :author_id
  has_many :definitions, :foreign_key => :author_id

  validates :name, presence: true

  def to_s
    name
  end
end
