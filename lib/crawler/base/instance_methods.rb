module Crawler
  module InstanceMethods
    def start!
      Thread.abort_on_exception = true

      @pages = []
      @pages_count = 0
      @pages_threads = []
      @total = 0
      @count = 0
      @threads_number = 20

      page = Nokogiri::HTML(open_url send(self.crawler_options[:store]).start_url)
      get_pages(page)
      finalize!
      self
      puts "Done! #{ @count }/#{ @total }"
    end

    def get_pages(page)
      @pages = send(self.crawler_options[:pages_urls], page).compact.uniq

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
        get_shoes Nokogiri::HTML(open_url url)
      rescue Exception => e
        log "\nerror on crawling #{ url }. Trying again..."
      end
    end

    def get_shoes(page)
      links = send(self.crawler_options[:shoes_urls], page).compact.uniq
      links -= Shoe.where('source_url in (?)', links).map(&:source_url)
      return if links.size == 0

      @total += links.size

      begin
        links.shuffle.each { |link| crawl_shoe(link) }
      rescue Exception => e
        fail_log "\n #{ e }\n" + e.backtrace.join("\n")
      end
    end

    def crawl_shoe(url)
      log "\ncrawling shoe #{ @count += 1 }/#{ @total } from #{ url }"
      page = Nokogiri::HTML(open_url url)
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