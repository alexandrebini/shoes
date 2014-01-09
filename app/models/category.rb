class Category < ActiveRecord::Base
  extend FriendlyId

  serialize :matchers
  has_many :shoes
  has_many :categories, through: :shoes
  has_many :brands, through: :shoes

  friendly_id :name, use: :slugged

  validates_presence_of :name

  def self.against(name)
    all.each do |category|
      matchers = (category.matchers.to_a + category.default_matchers).compact.uniq
      matchers.each do |matcher|
        if name =~ Regexp.new(matcher, Regexp::IGNORECASE)
          return category.name
        end
      end
    end
    return nil
  end

  def default_matchers
    [
      name,
      name.singularize,
      slug,
      slug.singularize,
      I18n.transliterate(name),
      I18n.transliterate(name.singularize)
    ]
  end
end