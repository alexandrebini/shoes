class Price < ActiveRecord::Base
  belongs_to :shoe

  validates_precense_of :value
end