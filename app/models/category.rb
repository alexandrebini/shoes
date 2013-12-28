class Category < ActiveRecord::Base
  extend FriendlyId

  has_many :shoes

  friendly_id :name, use: :slugged

  validates_presence_of :name
end