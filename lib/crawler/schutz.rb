module Crawler
  class Schutz
    extend Crawler::ActMacro

    acts_as_crawler

    def brand
      # this site is almost the same of Corello.
      @brand ||= Brand.where(name: 'Schutz').first
    end

    def pages_urls(page)
      categories_urls(page).map do |category_url|
        category_pages Nokogiri::HTML(open_url category_url)
      end
    end

    def shoes_urls(page, options={})
      page.css('.prodName a').map do |a|
        a.attr(:href)
      end
    end

    def parse_shoe(options)
      options[:product_view] = product_view(options)
      shoe = Shoe.where(source_url: options[:url]).lock(true).first_or_initialize
      shoe.update_attributes({
        brand: brand,
        source_url: options[:url],
        name: parse_name(options[:page]),
        description: parse_description(options[:page]),
        category_name: parse_category_name(options[:page]),
        price: parse_price(options[:page]),
        category_name: parse_category_name(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options),
        color_set: parse_colors(options),
        crawled_at: Time.now
      })
    end

    def parse_name(page)
      page.css('h1.titProduto').text.strip.mb_chars.titleize
    end

    def parse_description(page)
      description = page.css('p.textDescricao').first
      return description.text.strip if description
    end

    def parse_price(page)
      page.css('script').text.match(/Pvalues\s\:\s\[.*\]/).to_s.scan(/\d+/).join.to_i
    end

    def parse_category_name(page)
      name = page.css('h1.titProduto').text.strip.mb_chars.downcase
      Category.matches(name) || name.split(' ').first
    end

    def parse_photos(page)
      url = page.css('#Zoom1').first.attr(:href)
      Array.new.tap do |photos|
        photos << url
        page.css('ul.lstThumbs li img').each do |img|
          next if img.attr(:src).blank?
          photos << img.attr(:src).gsub('Detalhes', 'Ampliada')
        end
      end
    end

    def parse_colors(options)
      options[:product_view].css('img.thumb').first.attr(:alt).split('/').map(&:strip)
    end

    def parse_grid(options)
      options[:product_view].css('.thumb_off a').map do |a|
        a.text.to_i if a.text.present?
      end
    end

    private
    def categories_urls(page)
      page.css('.mnu1 ul.submenu li a').map do |a|
        if Category.matches(a.text.strip.mb_chars.downcase)
          a.attr(:href)
        end
      end.compact.uniq
    end

    def category_pages(page)
      total_pages = page.css('.barra_paginacao a').map{ |r| r.text.to_i }.max rescue 1
      category_id = page.css('#CategoriaCodigo').first.attr(:value)

      Array.new.tap do |pages|
        1.upto(total_pages).each do |page|
          pages << "#{ brand.url }/cat/#{ category_id }/0/MaisRecente/Decrescente/20/2////.aspx"
        end
      end
    end

   def product_view(options)
      product_id = options[:page].css('meta[name="itemId"]').first.attr(:content)

      # We need 2 call to do it.
      # first, we need to get the color code using CarregaSKU
      response = api_call('CarregaSKU', "{\"ProdutoCodigo\":\"#{ product_id }\"}", options[:url])
      product_code = response[4]

      # then we call DisponibilidadeSKU sending the product code
      body = "{\"ProdutoCodigo\":\"#{ product_id }\",\"CarValorCodigo1\":\"0\",\"CarValorCodigo2\":\"#{ product_code }\",\"CarValorCodigo3\":\"0\",\"CarValorCodigo4\":\"0\",\"CarValorCodigo5\":\"0\"}"
      response = api_call('DisponibilidadeSKU', body, options[:url])
      Nokogiri::HTML response.join
    end

    def api_call(method, body, shoe_url)
      api_url = "#{ brand.url }/ajaxpro/IKCLojaMaster.detalhes,Schutz.ashx"
      api_uri = URI.parse(api_url)
      shoe_uri = URI.parse(shoe_url)

      # they use some security, so we need to send cookies and all headers above
      cookies = Net::HTTP.start(shoe_uri.host, 80) do |http|
        http.head(shoe_uri.path)['Set-Cookie']
      end
      request = Net::HTTP::Post.new(api_url)
      request.add_field 'Cookie', cookies
      request.add_field 'X-AjaxPro-Method', method
      request.add_field 'Origin', brand.url
      request.add_field 'Referer', shoe_url
      request.body = body

      http = Net::HTTP.new(api_uri.host, api_uri.port)
      JSON.parse(http.request(request).body)['value']
    end
  end
end