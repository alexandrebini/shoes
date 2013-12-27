class Price < ActiveRecord::Base
  belongs_to :shoe

  validates_presence_of :value
end