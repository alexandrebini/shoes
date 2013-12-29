class Photo < ActiveRecord::Base
  belongs_to :shoe
  has_one :store, through: :shoe

  has_attached_file :data,
    path: ':rails_root/public/system/shoes/:id_partition/:basename_:style_:fingerprint.:extension',
    url: '/system/:attachment/shoes/:id_partition/:basename_:style_:fingerprint.:extension'

  validates :source_url, uniqueness: true, presence: true

  # scopes
  scope :random, -> { order('RAND()') }
  scope :downloading, -> { where(status: 'downloading') }
  scope :downloaded, -> { where(status: 'downloaded') }
  scope :pending, -> { where(status: 'pending') }
  scope :recent, -> { order('wallpapers.created_at DESC') }

  # callbacks
  # after_create :download_image

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
    Crawler.const_get("#{ store.slug.titleize }::Worker")
  end
end