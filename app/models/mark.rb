class Mark < ActiveRecord::Base
  attr_accessible :name, :description, :category

  belongs_to :category, class_name: 'MarkCategory',
    :foreign_key => :mark_category_id, :inverse_of => :marks

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
end
