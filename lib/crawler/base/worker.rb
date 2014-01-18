module Crawler
  class Worker
    def perform(photo_id)
      @photo = Photo.find(photo_id)

      unless @photo.downloading?
        download_logger "\nShoe #{ @photo.id } is not downloading. Current status: #{ @photo.status }"
        return
      end

      @filename = File.basename URI.parse(@photo.source_url).path
      @file = StringIO.new(Crawler::UrlOpener.instance.open_url @photo.source_url,
        proxy: false, min_size: 5.kilobytes, image: true, name: @photo.brand.slug)
      @file.original_filename = @filename

      @photo.data = @file
      @photo.data_file_name = @filename
      @photo.status = 'downloaded'

      if @photo.save
        download_logger "\nShoe #{ @photo.id } image: #{ @photo.source_url }"
      else
        raise @photo.errors.full_messages.join(' ')
      end
    rescue Exception => e
      if @photo
        @photo.status = 'pending'
        @photo.save(validate: false)
        download_logger "\nError on photo #{ @photo.id }: #{ @photo.source_url }. #{ e }" + e.backtrace.join("\n")
      else
        download_logger "\nError on photo #{ photo_id }. #{ e }"
      end
      return false
    ensure
      @file.close rescue nil
    end

    def download_logger(msg)
      logger = if @photo.present?
        Logger.new("#{ Rails.root }/log/#{ @photo.brand.slug }.downloads.log")
      else
        Logger.new("#{ Rails.root }/log/download_error.log")
      end
      puts msg
      logger << msg
    end
  end
end