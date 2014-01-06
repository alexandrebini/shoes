module Crawler
  class Louloux
    extend Crawler::ActMacro

    acts_as_crawler

    def initialize
      super
      @threads_number = 2
      @sleep_time = 5
    end

    def store
      @store ||= Store.where(name: 'Louloux').first
    end

    def brand
      @brand ||= Brand.where(name: 'Louloux').first
    end

    def pages_urls(page)
      total_pages = page.css('.page-number span a').map{ |r| r.text.to_i }.max

      Array.new.tap do |pages|
        pages << store.start_url
        2.upto(total_pages).each do |page|
          pages << "#{ store.url }/ver-todos-s32/?pagina=#{ page }&order=lancamento"
        end
      end
    end

    def shoes_urls(page, options={})
      page.css('.product .product-name a').map do |a|
        a.attr(:href)
      end
    end

    def parse_shoe(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      shoe.update_attributes({
        store: store,
        brand: brand,
        source_url: options[:url],
        name: parse_name(options[:page]),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        category_name: parse_category_name(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options[:page]),
        color_set: parse_colors(options),
        crawled_at: Time.now
      })
    end

    def parse_name(page)
      page.css('h1').text.strip.mb_chars.titleize
    end

    def parse_description(page)
      page.css('.description.summary').text.strip.humanize
    end

    def parse_price(page)
      page.css('.sale').text.scan(/\d+/).join.to_i
    end

    def parse_category_name(page)
      page.css('span.category').text.strip.mb_chars.downcase
    end

    def parse_photos(page)
      page.css('.product-photos ul li').map do |li|
        "#{ store.url }#{ li.attr(:title) }"
      end
    end

    def parse_colors(options)
      []
    end

    def parse_grid(page)
      page.css('#variations .size-box label').map do |label|
        label.text.to_i if label.text.present?
      end
    end
  end
end