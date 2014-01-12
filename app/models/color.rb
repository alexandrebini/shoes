class Color < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  has_and_belongs_to_many :palettes
  has_and_belongs_to_many :shoes

  friendly_id :name, use: :slugged

  validates_presence_of :name
  after_create :add_to_palette

  def add_to_palette
    if palette_name = Palette.matches(name)
      Palette.where(name: palette_name).first.colors << self
    end
  end
end