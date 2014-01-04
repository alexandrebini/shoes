class Brand < ActiveRecord::Base
  extend FriendlyId

  has_many :shoes

  friendly_id :name, use: :slugged
  has_attached_file :logo,
    path: ':rails_root/public/system/:attachment/:id/:basename_:style.:extension',
    url: '/system/:attachment/:id/:basename_:style.:extension'

  validates_presence_of :name

  def logo_path=path
    io = open(path)


    self.logo = io
    self.original_filename = File.basename io

    # self.logo = File.open path if File.exists?(path)
  end
end