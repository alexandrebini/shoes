class Category < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  serialize :matchers
  has_many :shoes
  has_many :brands, through: :shoes

  friendly_id :name, use: [:slugged, :finders]

  validates_presence_of :name

  scope :with_shoes, -> { joins(:shoes).uniq }
end