class Numeration < ActiveRecord::Base
  belongs_to :shoe

  validates_presence_of :number
end