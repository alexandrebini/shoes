namespace :shoes do
  desc 'status'
  task status: :environment do
    include ActionView::Helpers::NumberHelper
    sources = Store.all.sort_by{ |r| r.shoes.downloaded.count }.reverse
    sources.each do |source|
      downloaded = "downloaded: #{ number_with_delimiter store.shoes.downloaded.count }"
      downloading = "downloading: #{ number_with_delimiter store.shoes.downloading.count }"
      pending = "pending: #{ number_with_delimiter store.shoes.pending.count }"
      puts "#{ store.slug.ljust(15) } #{ downloaded.ljust(25) } #{ downloading.ljust(25) } #{ pending.ljust(25) }"
    end

    downloaded = "downloaded: #{ number_with_delimiter Shoe.downloaded.count }"
    downloading = "downloading: #{ number_with_delimiter Shoe.downloading.count }"
    pending = "pending: #{ number_with_delimiter Shoe.pending.count }"
    puts "#{ 'Total'.ljust(15) } #{ downloaded.ljust(25) } #{ downloading.ljust(25) } #{ pending.ljust(25) }"

    sleep(60)
    puts
    redo
  end

  desc 'Cleanup'
  task cleanup: :environment do
    shoes = Shoe.downloaded
    corrupted = []
    slice_size = shoes.count / 4 rescue 1
    shoes.each_slice(slice_size).map do |shoes_slice|
      Thread.new do
        shoes_slice.each do |shoe|
          case
          when File.exists?(shoe.image.path) == false
            corrupted.push shoe
          when File.extname(shoe.image.path) == '.jpg' && system("jpeginfo -c \"#{ shoe.image.path }\" | grep -E \"WARNING|ERROR\"")
            corrupted.push shoe
          end
        end
      end
    end.each(&:join)

    corrupted.each do |shoe|
      shoe.image.destroy
      shoe.download_image
    end

    puts "#{ corrupted.count }/#{ shoes.count } corrupted"
  end
end