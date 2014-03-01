class Mark < ActiveRecord::Base
  attr_accessible :name, :description, :category

  belongs_to :category, class_name: 'MarkCategory',
    :foreign_key => :mark_category_id, :inverse_of => :marks

  has_and_belongs_to_many :synset_words,
    join_table: 'current_synset_words_marks'

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
end
