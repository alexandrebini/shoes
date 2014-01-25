module Crawler
  class Tanara
    extend Crawler::ActMacro

    acts_as_crawler

    def brand
      @brand ||= Brand.where(name: 'Tanara').first
    end

    def pages_urls(page)
      page.css('.bordaBottomMenu').css('a:first').map do |a|
        name = a.text.strip.mb_chars.downcase
        puts "#{ name }: #{ Category.matches(name) }"
        if name = Category.matches(name)
          "#{ brand.start_url }/#{ a.attr(:href) }"
        end
      end[0..1]
    end

    def shoes_urls(page, options={})
      page.css('.thumbHome td a img').map do |a|
        "#{ brand.start_url }/#{ a.parent.attr(:href) }"
      end
    end

    def parse_shoe(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      shoe.update_attributes({
        brand: brand,
        source_url: options[:url],
        name: parse_name(options[:page]),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        category_name: parse_category_name(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options[:page]),
        color_set: parse_colors(options[:page]),
        crawled_at: Time.now
      })
    end

    def parse_name(page)
      page.css('.titProduto').text.strip.mb_chars
    end

    def parse_description(page)
      page.css("img[src='img/titespecificacoes.gif']").first.parent.parent.css('span').map do |span|
        span.text.squish
      end.join("\n")
    end

    def parse_price(page)
      page.css('.parcelas tr:eq(2) td.bgC').last.text.scan(/\d+/).join.to_i
    end

    def parse_category_name(page)
      page.css('#contProdAmpli span a').reverse.each do |a|
        name = a.text.strip.mb_chars.downcase
        if name = Category.matches(name)
          return name
        end
      end
      nil
    end

    def parse_photos(page)
      page.css('.thumbs img').map do |img|
        src = img.attr(:src).split('/').last
        "#{ brand.start_url }/img.php?i=imagens_produtos/#{ src }"
      end
    end

    def parse_colors(page)
      colors = page.css("strong[text()*='Cor']").first.parent.next.next.text.squish
      colors.split(' ').map { |color| color.split('/') }.flatten.compact.uniq
    end

    def parse_grid(page)
      page.css('#tamanho option').map do |option|
        size = option.text.to_i
        size if size > 0
      end
    end
  end
end