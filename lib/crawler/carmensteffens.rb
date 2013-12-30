module Crawler
  class Carmensteffens
    extend Crawler::ActMacro

    acts_as_crawler

    def initialize
      super
      @threads_number = 10
      @sleep_time = 5
    end

    def store
      @store ||= Store.where(name: 'CarmenSteffens').first
    end

    def categories
      @categories ||= {}
    end

    def pages_urls(page)
      categories_urls(page).map do |category_url|
        category_colors(Nokogiri::HTML(open category_url))
      end
    end

    def shoes_urls(page, options={})
      page.css('#lista ul li.produto table tr td div a').map do |a|
        referer = options[:referer].gsub(/\/pag(.*)/, '')
        categories[category_name(page: page)].each do |category|
          category[:shoes].push(a.attr(:href)) if category.has_value?(referer)
        end

        a.attr(:href)
      end
    end

    def parse_shoe(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      shoe.update_attributes({
        store: store,
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
      page.css('.basic-info h2').text
    end

    def parse_description(page)
      page.css('span.description').text
    end

    def parse_price(page)
      page.css('.valoresProduto .preco').text.scan(/\d+/).join.to_i
    end

    def parse_photos(page)
      Array.new.tap do |photos|
        photos << page.css('.main-photo img.main-image').attr('src').text.gsub(/580/, '1500')
        images = page.css('.thumbnails a img')
        images.map do |image|
          photos << image.attr('src').gsub(/100/, '1500')
        end
      end
    end

    def parse_grid(page)
      sizes = page.css('ul.atributos li:not(.sem)')
      sizes.map do |size|
        size.text.scan(/\d+/).first.to_i
      end
    end

    def parse_colors(options)
      category_name = category_name({page: options[:page], selector: '.basic-info h5'})
      categories[category_name].map do |category|
        category[:color_name] if category[:shoes].include?(options[:url])
      end.compact
    end

    def parse_category_name(page)
      category_name({page: page, selector: '.basic-info h5'})
    end

    private
    def category_name(options)
      selector = options[:selector] || '#menu h3 a'
      options[:page].css(selector).text.gsub(/\s/, '')
        .force_encoding('iso-8859-1').encode('utf-8').mb_chars.downcase.to_s
    end

    def categories_urls(page)
      page.css('.cat-menu .holder ul li:eq(2) ul#subMenu:first li a').map do |a|
        if Category.against(a.text.strip.force_encoding('iso-8859-1').encode('utf-8').mb_chars.downcase)
          a.attr(:href)
        end
      end.compact.uniq
    end

    def category_colors(page)
      colors = page.css('ul.containerN1 li.containerN2 ul li.filtroTamanhos a img')
      category_name = category_name(page: page)
      categories[category_name] = []
      block_color_list = {
        'botas' => ['Branco'],
        'peeptoes' => ['Off White']
      }

      colors.map do |color|
        next if block_color_list.has_key?(category_name) && block_color_list[category_name].include?(color.attr('alt'))
        category_id = page.css('span.paginacao:not(.seta) a').first.attr('href').match(/\/departamento\/(.*\d+)\//)[1].to_i
        url = "http://www.carmensteffens.com.br/departamento/#{ category_id }/cor/#{ color.attr('src').match(/\d+/).to_a.join }"
        categories[category_name] << {
          color_name: color.attr('alt'),
          referer: url,
          shoes: []
        }

        category_pages Nokogiri::HTML(open url)
      end
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