class User < ActiveRecord::Base
  devise :omniauthable
  attr_accessible :name, :provider, :uid
  validates :name, presence: true
end
