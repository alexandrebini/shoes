module Crawler
  class Melissa
    extend Crawler::ActMacro

    acts_as_crawler

    def store
      @store ||= Store.where(name: 'Melissa').first
    end

    def shoes_categories
      @shoes_categories ||= {}
    end

    def pages_urls(page)
      cats = page.css('.attribute-filter.estilo ol li a')

      Array.new.tap do |pages|
        pages << store.start_url
        cats.each do |cat|
          shoes_categories[cat.attr(:href)] = {
            name: cat.attr(:title),
            shoes: []
          }

          pages << cat.attr(:href)
        end
      end
    end

    def shoes_urls(page, options={})
      page.css('ul.products-grid li.item .product-name a').map do |a|
        shoes_categories[options[:referer]][:shoes].push a.attr(:href)
        a.attr(:href)
      end
    end

    def create_shoe(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      shoe.update_attributes(
        store: store,
        category_name: parse_category_name(options),
        source_url: options[:url],
        name: parse_name(options),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        photos_urls: parse_photos(options),
        grid: parse_grid(options[:page]),
        color_set: parse_colors(options),
        brand_name_url: parse_brand(options[:page]),
        crawled_at: Time.now
      )
    end

    def parse_category_name(options)
      shoes_categories.map do |category|
        category.last[:name] if category.last[:shoes].include?(options[:url])
      end.compact.first
    end

    def parse_brand(page)
      link_brand = page.css('.sector_two_and_three .footer_treatment div a').last
      { name: link_brand.text.match(/Melissa/).to_a.first, url: link_brand.attr(:href) }
    end

    def parse_shoe(options)
      script = options[:page].css('#product-options-wrapper script').first
      script ? script = script.text : return
      parent_id = script.match(/ptId(.*)\;/).to_a.first.scan(/\d+/).first.to_i
      product_ids = script.scan(/\"\d+\":\"\d+\"/).map do |r|
        r.split(':').last.gsub('"', '').to_i
      end

      product_ids.each do |product_id|
        options[:product_view] = product_view(parent_id: parent_id, product_id: product_id)
        create_shoe(options)
      end
    end

    def parse_name(options)
      options[:product_view].css('img').first.attr(:title)
    end

    def parse_description(page)
      page.css('.description .std').text.strip
    end

    def parse_price(page)
      page.css('.price .customize-price').last.text.scan(/\d+/).join.to_i
    end

    def parse_photos(options)
      [options[:product_view].css('img').first.attr(:src)]
    end

    def parse_colors(options)
      title = options[:product_view].css('img').first.attr(:title)
      colors = title.match(/\(.*\)$/).to_a.first
      colors = title.match(/\-(.*)$/).to_a.first unless colors
      return unless colors
      colors.split('/').map do |color|
        color.gsub(/\(|\)/, '').strip
      end
    end

    def parse_grid(page)
      sizes = page.css('.product-options').first.text
        .match(/spConfig(.*)/).to_a.first
        .match(/Tamanho\"\,\"options\"\:(.*)/).to_a.first

      sizes.scan(/"label":"\d+\"/).map do |size|
        size.split(':').last.gsub(/\D/, '').to_i
      end
    end

    private
    def product_view(options)
      uri = URI('http://lojamelissa.com.br/ajaxrequests/ProductView/productBlocks')
      res = Net::HTTP.post_form(uri, productId: options[:product_id], parentId: options[:parent_id])
      Nokogiri::HTML JSON.parse(res.body)['media-block']
    end
  end
end