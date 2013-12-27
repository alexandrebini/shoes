class Palette < ActiveRecord::Base
  has_and_belongs_to_many :colors

  validates_presence_of :name, :hex
end