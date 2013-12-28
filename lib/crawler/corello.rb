module Crawler
  class Corello
    extend Crawler::ActMacro

    acts_as_crawler

    def store
      @store ||= Store.where(name: 'Corello').first
    end

    def pages_urls(page)
      total_pages = page.css('li.numbers a').last.text.to_i

      Array.new.tap do |pages|
        pages << store.start_url
        2.upto(total_pages).each do |page|
          pages << "#{ store.url }/categoria/1/2/0/MaisRecente/Decrescente/60/#{ page }//0/0/.aspx"
        end
      end
    end

    def shoes_urls(page)
      page.css('a[rel="product"]').map do |a|
        a.attr(:href)
      end
    end

    def parse_shoe(options)
      options[:product_view] = product_view(options)

      Shoe.create(
        store: store,
        source_url: options[:url],
        name: parse_name(options[:page]),
        description: parse_description(options[:page]),
        price: parse_price(options[:page]),
        photos_urls: parse_photos(options[:page]),
        grid: parse_grid(options),
        color_set: parse_colors(options)
      )
    end

    def parse_name(page)
      page.css('h1.name').text.strip
    end

    def parse_description(page)
      divs = page.css('#description').children[2..-1]
      return divs.map(&:text).join("\n").strip if divs.present?
    end

    def parse_price(page)
      page.css('#lblPrecoPor').text.scan(/\d+/).join.to_i
    end

    def parse_photos(page)
      url = page.css('#Zoom1').first.attr(:href)
      thumbs = page.css('ul.thumbs li img').map{ |r| r.attr(:src) }.compact.uniq
      Array.new.tap do |photos|
        photos << url
        1.upto(thumbs.size - 1).each do |thumb|
          photos << url.gsub('Ampliada', "Ampliada#{ thumb }")
        end
      end
    end

    def parse_colors(options)
      options[:product_view].css('li img').first.attr(:alt).split('/').map(&:strip)
    end

    def parse_grid(options)
      options[:product_view].css('ul li.select a').map do |a|
        a.text.to_i if a.text.present?
      end
    end

    private
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
      api_url = 'http://shop.corello.com.br/ajaxpro/IKCLojaMaster.detalhes,Corello.ashx'
      api_uri = URI.parse(api_url)
      shoe_uri = URI.parse(shoe_url)

      # they use some security, so we need to send cookies and all headers above
      cookies = Net::HTTP.start(shoe_uri.host, 80) do |http|
        http.head(shoe_uri.path)['Set-Cookie']
      end
      request = Net::HTTP::Post.new(api_url)
      request.add_field 'Cookie', cookies
      request.add_field 'X-AjaxPro-Method', method
      request.add_field 'Origin', store.url
      request.add_field 'Referer', shoe_url
      request.body = body

      http = Net::HTTP.new(api_uri.host, api_uri.port)
      JSON.parse(http.request(request).body)['value']
    end
  end
end