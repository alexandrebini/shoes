require "#{ Rails.root }/lib/crawler/crawler"

namespace :crawler do
  desc 'import all shoes'
  task start: :environment do
    [
      Thread.new{ Crawler::Goodfon.start! },
      Thread.new{ Crawler::Hdshoes.start! },
      Thread.new{ Crawler::Interfacelift.start! }
    ].each(&:join)
  end

  desc 'start downloads'
  task download: :environment do
    jobs = 10
    puts "Starting #{ jobs } jobs..."
    Shoe.pending.random.limit(jobs).each do |shoe|
      shoe.download_image
    end
  end

  desc 'restart downloads'
  task restart_downloads: :environment do
    Thread.abort_on_exception = true

    reset_shoes_attributes!

    queue = enqueue_local_shoes

    puts "let's work..."
    puts "#{ queue[:total_downloaded] } downloaded"
    puts "#{ queue[:total] - queue[:total_downloaded] } to download"
    Rake::Task['crawler:download'].invoke
  end

  def reset_shoes_attributes!
    # clear shoes
    Shoe.update_all(image_file_name: nil, image_content_type: nil,
      image_file_size: nil, image_updated_at: nil, image_meta: nil,
      image_fingerprint: nil)

    # clean colors
    Color.connection.execute "TRUNCATE TABLE shoes_colors;"
    Color.connection.execute "TRUNCATE TABLE colors;"
    Color.destroy_all
    Shoe.update_all(status: 'pending')
  end

  def move_images_to_tmp!
    tmp_dir = "#{ Rails.root }/public/system/shoes_tmp"
    FileUtils.mkdir_p tmp_dir

    Dir["#{ Rails.root }/public/system/shoes/**/*_original.*"].each do |file|
      FileUtils.mv file, tmp_dir
    end
  end

  def cleanup_images_dir!
    puts "Are you sure you want to delete the shoes dir? 5 seconds to think about it..."
    sleep(5)
    FileUtils.rm_rf "#{ Rails.root }/public/system/shoes/"
  end
end