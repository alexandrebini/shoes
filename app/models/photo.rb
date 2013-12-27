class Photo < ActiveRecord::Base
  belongs_to :shoe

  has_attached_file :data,
    path: ':rails_root/public/system/:attachment/:id/:fingerprint/:basename_:style.:extension',
    url: '/system/:attachment/:id/:fingerprint/:basename_:style.:extension'

  validates_presence_of :source_url
end