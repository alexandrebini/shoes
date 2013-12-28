module Crawler
  class Melissa
    extend Crawler::ActMacro

    acts_as_crawler

    def store
      @store ||= Store.where(name: 'Melissa').first
    end

    def categories
      @categories ||= { }
    end

    def pages_urls(page)
      cats = page.css('.attribute-filter.estilo ol li a')

      Array.new.tap do |pages|
        pages << store.start_url
        cats.each do |cat|
          category = create_category(cat.attr(:title).downcase)
          href = cat.attr(:href)
          set_categories({url: href, category: category})
          pages << href
        end
      end
    end

    def set_categories(options)
      type = options.url.match(/arquetipo\=(.*)/).to_i
      categories[type] = category
    end

    def shoes_urls(page)
      page.css('ul.products-grid li.item .product-name a').map do |a|
        a.attr(:href)
      end
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

    def parse_category_name(page)
      category_name = page.css('.attribute-filter.estilo .item-filtered').text
        .gsub('Excluir Este Item', '')
      p '====================='
      p '====================='
      p '====================='
      p '====================='

      p page
      p '====================='
      p '====================='
      p '====================='
      categories[category_name.downcase]
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
    def create_shoe(options)
      Shoe.create(
        store: store,
        category: parse_category_name(options[:page]),
        source_url: options[:url],
        name: parse_name(options),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        photos_urls: parse_photos(options),
        grid: parse_grid(options[:page]),
        color_set: parse_colors(options)
      )
    end

    def create_category(name)
      Category.where(
        name: name
      ).first_or_create
    end

    def product_view(options)
      uri = URI('http://lojamelissa.com.br/ajaxrequests/ProductView/productBlocks')
      res = Net::HTTP.post_form(uri, productId: options[:product_id], parentId: options[:parent_id])
      Nokogiri::HTML JSON.parse(res.body)['media-block']
    end
  end
end