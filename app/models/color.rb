class Color < ActiveRecord::Base
  extend FriendlyId

  has_and_belongs_to_many :palettes
  has_and_belongs_to_many :shoes

  friendly_id :title, use: :slugged

  validates_presence_of :name
end