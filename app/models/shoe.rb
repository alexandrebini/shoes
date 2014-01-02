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

  scope :available, -> { joins(:numerations).uniq }
  scope :random, -> { order('RAND()') }
  scope :downloading, -> { joins(:photos).where(photos: { status: 'downloading' }).uniq }
  scope :downloaded, -> { joins(:photos).where(photos: { status: 'downloaded' }).uniq }
  scope :pending, -> { joins(:photos).where(photos: { status: 'pending' }).uniq }
  scope :ready, -> { downloaded.available }

  def available?
    numerations.present?
  end

  def price=value
    unless prices.last && prices.last.value == value
      self.prices.build(value: value)
    end
  end

  def price
    prices.last.value/100 if prices.last
  end

  def photos_urls=urls
    urls.compact.uniq.each do |url|
      unless photos.where(source_url: url).lock(true).exists?
        photos.build(source_url: url)
      end
    end
  end

  def photo
    photos.first
  end

  def grid=numerations
    new_numerations = numerations.compact.uniq.map do |numeration|
      self.numerations.where(number: numeration).first_or_initialize
    end
    self.numerations.replace new_numerations
  end

  def color_set=colors
    new_colors = colors.compact.uniq.map do |color|
      Color.where(name: color.mb_chars.titleize).lock(true).first_or_initialize
    end
    self.colors.replace new_colors
  end

  def category_name=name
    name = Category.against(name) || name.to_s
    self.category = Category.where(name: name.mb_chars.titleize.pluralize).lock(true).first_or_create
  end

  def brand_name_url=options
    self.brand = Brand.where(
      name: options[:name].mb_chars.downcase,
      url: options[:url]).lock(true).first_or_create
  end
end