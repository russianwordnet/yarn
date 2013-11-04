class MarkCategory < ActiveRecord::Base
  attr_accessible :title

  has_many :marks, :inverse_of => :category, :dependent => :destroy

  validates :title, presence: true, uniqueness: true
end
