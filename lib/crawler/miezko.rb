module Crawler
  class Miezko
    extend Crawler::ActMacro

    acts_as_crawler

    def initialize
      super
      @threads_number = 2
      @sleep_time = 5
    end

    def store
      @store ||= Store.where(name: 'Miezko').first
    end

    def pages_urls(page)
      page.css('.page-number a').map do |a|
        a.attr(:href)
      end
    end

    def shoes_urls(page, options={})
      page.css('a.details').map do |a|
        a.attr(:href)
      end
    end

    def parse_shoe(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      p '-----------------'
      p shoe.update_attributes(
        store: store,
        category_name: parse_category_name(options[:page]),
        source_url: options[:url],
        name: parse_name(options[:page]),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options[:page]),
        crawled_at: Time.now
      )
      p shoe.errors

    end

    def parse_category_name(page)
      page.css('.fn').text.split('-').first.strip.mb_chars.downcase
    end

    def parse_name(page)
      names = page.css('.fn').text.split('-').map(&:strip)
      names[0...-1].join(' ').mb_chars.titleize
    end

    def parse_description(page)
      page.css('.info-description').text.strip
    end

    def parse_price(page)
      page.css('.purchase-info .sale-price .sale').text.scan(/\d+/).join.to_i
    end

    def parse_photos(page)
      page.css('ul.product-photos-list a').map do |a|
        "#{ store.url }#{ a.attr(:href) }"
      end
    end

    def parse_grid(page)
      page.css('.size-box.box label').map do |label|
        label.attr(:title).strip.to_i
      end
    end
  end
end