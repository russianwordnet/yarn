class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:finders]

  attr_accessible :title, :body, :slug

  belongs_to :author, class_name: 'User'

  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true
  validates :author, presence: true

  validate do
    errors.add(:base, 'Must be an admin to write posts') unless author.try(:admin?)
  end

  scope :new_at_top, -> { order(created_at: :desc) }
end
