module Crawler
  class Corello
    extend Crawler::ActMacro

    acts_as_crawler

    def brand
      @brand ||= Brand.where(name: 'Corello').first
    end

    def pages_urls(page)
      categories_urls(page).map do |category_url|
        category_pages Nokogiri::HTML(open_url category_url)
      end
    end

    def shoes_urls(page, options={})
      page.css('a[rel="product"]').map do |a|
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
        price: parse_price(options[:page]),
        category_name: parse_category_name(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options),
        color_set: parse_colors(options),
        crawled_at: Time.now
      })
    end

    def parse_name(page)
      page.css('h1.name').text.strip
    end

    def parse_description(page)
      divs = page.css('#description').children[2..-1]
      return divs.map(&:text).join("\n").strip if divs.present?
    end

    def parse_price(page)
      page.css('script').text.match(/Pvalues\s\:\s\[.*\]/).to_s.scan(/\d+/).join.to_i
    end

    def parse_category_name(page)
      reject = %(home todos)
      links = page.css('#breadcrumbs li a')
      links = page.css('#breadcrumbs li strong') if links.size == 1
      candidates = [page.css('h1.name').text.strip]
      candidates += links.map do |a|
        name = a.text.strip.mb_chars.downcase
        name unless reject.include?(name)
      end
      candidates.each do |candidate|
        if name = Category.against(candidate)
          return name
        end
      end
      nil
    end

    def parse_photos(page)
      url = page.css('#Zoom1').first.attr(:href)
      Array.new.tap do |photos|
        photos << url
        page.css('ul.thumbs li img').each do |img|
          next if img.attr(:src).blank?
          photos << img.attr(:src).gsub('Detalhes', 'Ampliada')
        end
      end
    end

    def parse_colors(options)
      options[:product_view].css('li a').first.attr(:title).split('/').map(&:strip)
    end

    def parse_grid(options)
      options[:product_view].css('ul li.select a').map do |a|
        a.text.to_i if a.text.present?
      end
    end

    private
    def categories_urls(page)
      page.css('#nav li a').map do |a|
        if Category.against(a.text.strip.mb_chars.downcase)
          a.attr(:href)
        end
      end.compact.uniq
    end

    def category_pages(page)
      total_pages = page.css('li.numbers a').last.text.to_i rescue 1
      category_id = page.css('#CategoriaCodigo').first.attr(:value)

      Array.new.tap do |pages|
        1.upto(total_pages).each do |page|
          pages << "http://shop.corello.com.br/categoria/1/#{ category_id }/0/MaisRecente/Decrescente/60/#{ page }//0/0/.aspx"
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
      api_url = "#{ brand.url }/ajaxpro/IKCLojaMaster.detalhes,Corello.ashx"
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