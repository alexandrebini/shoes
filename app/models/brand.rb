class Brand < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  has_many :shoes
  has_many :categories, through: :shoes

  friendly_id :name, use: [:slugged, :finders]
  has_attached_file :logo,
    path: ':rails_root/public/system/brands/:id_partition/:basename_:style_:fingerprint.:extension',
    url: '/system/brands/:id_partition/:basename_:style_:fingerprint.:extension',
    styles: {
      thumb: '200x180'
    },
    processors: [:thumbnail, :compression]

  validates_presence_of :name, :url, :start_url, :verification_matcher

  scope :with_shoes, -> { joins(:shoes).uniq }

  def logo_path=path
    self.logo = File.open path if File.exists?(path)
  end
end