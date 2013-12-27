class Shoe < ActiveRecord::Base
  extend FriendlyId

  belongs_to :brand
  belongs_to :store
  has_many :photos, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :numerations, dependent: :destroy
  has_and_belongs_to_many :colors

  friendly_id :name, use: :slugged

  validates_presence_of :description, :name
end