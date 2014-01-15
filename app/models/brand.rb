class Brand < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  has_many :shoes

  friendly_id :name, use: :slugged
  has_attached_file :logo,
    path: ':rails_root/public/system/shoes/:id_partition/:basename_:style_:fingerprint.:extension',
    url: '/system/shoes/:id_partition/:basename_:style_:fingerprint.:extension',
    styles: {
      thumb: '200x180'
    }

  validates_presence_of :name, :start_url, :verification_matcher

  scope :with_shoes, -> { joins(:shoes).uniq }

  def logo_path=path
    self.logo = File.open path if File.exists?(path)
  end
end