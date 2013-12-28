module Crawler
  class CarmenSteffens
    extend Crawler::ActMacro

    acts_as_crawler

    def store
      @store ||= Store.where(name: 'Carmen Steffens').first
    end

    def pages_urls(page)
      categories_urls(page).map do |category_url|
        category_pages(Nokogiri::HTML(open category_url))
      end
    end

    def shoes_urls(page, options={})
      page.css('#lista ul li.produto table tr td div a').map do |a|
        a.attr(:href)
      end
    end

    def parse_shoe(options)
      p '------------------------'
      p parse_name(options[:page])
      p parse_description(options[:page])
      p parse_price(options[:page])
      p parse_photos(options[:page])
      # shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      # shoe.update_attributes({
      #   store: store,
      #   source_url: options[:url],
      #   name: parse_name(options[:page]),
      #   description: parse_description(options[:page]),
      #   category_name: parse_category_name(options[:page]),
      #   price: parse_price(options[:page]),
      #   category_name: parse_category_name(options[:page]),
      #   photos_urls: parse_photos(options[:page]),
      #   grid: parse_grid(options),
      #   color_set: parse_colors(options),
      #   crawled_at: Time.now
      # })
    end

    def parse_name(page)
      page.css('.basic-info h2').text
    end

    def parse_description(page)
      page.css('span.description').text
    end

    def parse_price(page)
      page.css('.preco').text.scan(/\d+/).join.to_i
    end

    def parse_photos(page)
      Array.new.tap do |photos|
        photos << page.css('.main-photo img.main-image').attr(:src).gsub(/467/, '1500')

        images = page.css('.thumbnails a img')
        images.map do |image|
          photos << image.attr(:src).gsub(/100/, '1500')
        end
      end
    end

    private
    def categories_urls(page)
      # crawl_categories = %w(anabelas botas chinelos peep\ toes rasteiras sandÁlias sapatilhas scarpins slippers sneakers tamancos tênis\ casual)
      crawl_categories = %w(anabelas)
      page.css('.cat-menu .holder ul li ul#subMenu:first li a').map do |a|

        if crawl_categories.include?(a.text.force_encoding('iso-8859-1').encode('utf-8').strip.downcase)
          a.attr(:href)
        end
      end.compact.uniq
    end

    def category_pages(page)
      pagination = page.css('span.paginacao a:not(.seta)')

      Array.new.tap do |pages|
        pagination.each do |page|
          pages << page.attr(:href)
        end
      end
    end
  end
end