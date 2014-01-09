class Brand < ActiveRecord::Base
  extend FriendlyId
  include Matcher

  has_many :shoes

  friendly_id :name, use: :slugged
  has_attached_file :logo,
    path: ':rails_root/public/system/:attachment/:id/:basename_:style.:extension',
    url: '/system/:attachment/:id/:basename_:style.:extension'

  validates_presence_of :name, :start_url, :verification_matcher

  def logo_path=path
    self.logo = File.open path if File.exists?(path)
  end
end