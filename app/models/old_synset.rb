class OldSynset < ActiveRecord::Base
  self.table_name = 'synsets'

  include Yarn::Trackable::Tail

  attr_accessible :words

  belongs_to :author, class_name: 'User'
end
