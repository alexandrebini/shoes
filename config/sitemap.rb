SitemapGenerator::Sitemap.default_host = Settings.host
SitemapGenerator::Sitemap.sitemaps_path = "#{ Rails.root }/public/system"
SitemapGenerator::Sitemap.include_root = false

SitemapGenerator::Sitemap.create do
  def paginate(lastmod: nil, collection: [], path: nil, url_options: {}, changefreq: 'daily', priority: 0.7)
    default_url_options = { trailing_slash: true }

    url = send path, default_url_options.merge(url_options)
    add url, priority: priority, lastmod: lastmod, changefreq: changefreq

    2.upto(collection.page(1).total_pages) do |page|
      url = send path, default_url_options.merge(url_options).merge({ page: page })
      add url, priority: priority, lastmod: lastmod, changefreq: changefreq
    end
  end

  paginate collection: Shoe.ready, path: :html_shoes_path, changefreq: 'always', priority: 1

  Brand.with_shoes.each do |brand|
    paginate collection: brand.shoes.ready, lastmod: brand.updated_at,
      path: :html_brand_shoes_path, url_options: { slug: brand.slug }
  end

  Category.with_shoes.each do |category|
    paginate collection: category.shoes.ready, lastmod: category.updated_at,
      path: :html_category_shoes_path, url_options: { slug: category.slug }

    category.brands.with_shoes.each do |brand|
      paginate collection: category.shoes.where(brand: brand),
        path: :html_category_brand_shoes_path, url_options: { slug: category.slug, brand: brand.slug }
    end
  end

  Shoe.ready.each do |shoe|
    add html_shoe_path(shoe.category.slug, shoe.brand.slug, shoe.slug, trailing_slash: true),
      priority: 0.5, lastmod: shoe.updated_at, changefreq: 'weekly'
  end
end