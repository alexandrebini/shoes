class Palette < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  serialize :matchers
  has_and_belongs_to_many :colors

  validates_presence_of :name, :hex
  friendly_id :name, use: [:slugged, :finders]
end