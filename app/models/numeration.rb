class Numeration < AtiveRecord::Base
  belongs_to :shoe

  validates_presence_of :number
end