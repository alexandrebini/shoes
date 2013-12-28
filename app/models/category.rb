class Category < ActiveRecord::Base
  extend FriendlyId

  has_many :shoes

  friendly_id :name, use: :slugged

  validates_presence_of :name

  def self.all_names
    self.all.map do |category|
      [category.name.downcase, category.name.singularize.downcase]
    end.flatten.compact.uniq
  end
end