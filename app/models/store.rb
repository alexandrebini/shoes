class Store < ActiveRecord::Base
  extend FriendlyId

  has_many :shoes

  friendly_id :name, use: :slugged
  has_attached_file :logo,
    path: ':rails_root/public/system/:attachment/:id/:basename_:style.:extension',
    url: '/system/:attachment/:id/:basename_:style.:extension'

  validates_presence_of :logo, :name, :start_url, :verification_matcher
end