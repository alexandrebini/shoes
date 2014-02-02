class Photo < ActiveRecord::Base
  belongs_to :shoe
  has_one :brand, through: :shoe

  delegate :url, :path, :image_size, :height, :width, to: :data
  has_attached_file :data,
    path: ':rails_root/public/system/shoes/:id_partition/:basename_:style_:fingerprint.:extension',
    url: '/system/shoes/:id_partition/:basename_:style_:fingerprint.:extension',
    styles: {
      original: { geometry: '' },
      thumb: '200x180',
      long: '200x360',
      wide: '400x180',
      big: '650x600'
    },
    convert_options: {
      original: '-fuzz 2% -trim +repage'
    },
    processors: [:thumbnail, :compression]

  validates :source_url, uniqueness: true, presence: true

  # scopes
  scope :random, -> { order('RAND()') }
  scope :downloading, -> { where(status: 'downloading') }
  scope :downloaded, -> { where(status: 'downloaded') }
  scope :pending, -> { where(status: 'pending') }
  scope :recent, -> { order('photos.created_at DESC') }

  # callbacks
  after_create :download_image

  # others
  def download_image
    self.status = 'downloading'
    self.save(validate: false)
    worker.perform_async(id) if source_url.present?
  end

  def downloading?
    status == 'downloading'
  end

  def pending?
    status == 'pending'
  end

  private
  def worker
    Crawler.const_get("#{ brand.slug.titleize }::Worker")
  end
end