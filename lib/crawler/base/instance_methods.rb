module Crawler
  module InstanceMethods

    def initialize
      Thread.abort_on_exception = true

      @semaphore = Mutex.new
      @threads_number ||= 20
      @sleep_time ||= 0
    end

    def start!
      @pages = []
      @pages_count = 0
      @pages_threads = []
      @shoes_urls = []
      @count = 0

      page = Nokogiri::HTML open_url(send(self.crawler_options[:store]).start_url), nil, 'utf-8'
      get_pages(page)
      finalize!
      self
      puts "Done! #{ @count }/#{ @shoes_urls.size }"
    end

    def get_pages(page)
      @pages = send(self.crawler_options[:pages_urls], page).flatten.compact.uniq

      begin
        @pages.shuffle.each_slice(slice_size @pages).map do |pages_slice|
          @pages_threads << Thread.new do
            pages_slice.each{ |page| crawl_page(page) }
          end
        end
      rescue Exception => e
        fail_log "\n #{ e }\n" + e.backtrace.join("\n")
      end
    end

    def crawl_page(url)
      log "\ncrawling a list of shoes #{ @pages_count += 1 }/#{ @pages.size } from #{ url }"
      begin
        get_shoes Nokogiri::HTML(open_url(url), nil, 'utf-8'), referer: url
      rescue Exception => e
        log "\nerror on crawling #{ url }. Trying again..."
        log "#{ e }\n#{ e.backtrace.join("\n") }"
      end
    end

    def get_shoes(page, options={})
      links = send(self.crawler_options[:shoes_urls], page, options).compact.uniq
      @semaphore.synchronize do
        links -= @shoes_urls
        @shoes_urls += links
      end
      return if links.size == 0

      begin
        links.shuffle.each { |link| crawl_shoe(link) }
      rescue Exception => e
        fail_log "\n #{ e }\n" + e.backtrace.join("\n")
      end
    end

    def crawl_shoe(url)
      log "\ncrawling shoe #{ @count += 1 }/#{ @shoes_urls.size } from #{ url }"
      page = Nokogiri::HTML(open_url(url), nil, 'utf-8')
      send(self.crawler_options[:parse_shoe], page: page, url: url)
    rescue Exception => e
      fail_log "\n#{ url }\t#{ e.to_s }\n#{ e.backtrace.join("\n") }"
    end

    def finalize!
      @pages_threads.each(&:join)
    end

    private
    def open_url(url, options={})
      default_options = {
        verification_matcher: self.store.verification_matcher,
        proxy: false,
        name: self.store.slug
      }
      options.merge!(default_options)
      sleep @sleep_time
      Crawler::UrlOpener.instance.open_url(url, options)
    end

    def slice_size(array)
      array.size > @threads_number ? array.size/@threads_number : array.size
    end

    def log(args)
      @logger ||= Logger.new("#{ Rails.root }/log/#{ self.store.slug }.log")
      @logger << args
      puts args
    end

    def fail_log(args)
      @fail_logger ||= Logger.new("#{ Rails.root }/log/#{ self.store.slug }.fail.log")
      @fail_logger << args
      @fail_logger << "\n"
    end
  end
end