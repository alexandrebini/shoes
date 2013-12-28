class Shoe < ActiveRecord::Base
  extend FriendlyId

  belongs_to :brand
  belongs_to :store
  belongs_to :category
  has_many :photos, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :numerations, dependent: :destroy
  has_and_belongs_to_many :colors

  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :source_url, presence: true

  def price=value
    unless prices.last && prices.last.value == value
      self.prices.build(value: value)
    end
  end

  def photos_urls=urls
    urls.compact.uniq.each do |url|
      unless photos.where(source_url: url).lock(true).exists?
        photos.build(source_url: url)
      end
    end
  end

  def grid=numerations
    new_numerations = numerations.compact.uniq.map do |numeration|
      self.numerations.where(number: numeration).first_or_initialize
    end
    self.numerations.replace new_numerations
  end

  def color_set=colors
    new_colors = colors.compact.uniq.map do |color|
      Color.where(name: color).lock(true).first_or_initialize
    end
    self.colors.replace new_colors
  end

  def category_name=name
    self.category = Category.where(name: name.downcase).lock(true).first_or_create
  end

  def brand_set=brand
    self.brand = Brand.where(brand).lock(true).first_or_create
  end
end