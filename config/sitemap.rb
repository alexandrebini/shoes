SitemapGenerator::Sitemap.default_host = Settings.host
SitemapGenerator::Sitemap.sitemaps_path = "#{ Rails.root }/public/system"

SitemapGenerator::Sitemap.create do
  Category.with_shoes.each do |category|
    add category_path(category.slug), priority: 0.7,
      lastmod: category.updated_at, changefreq: 'weekly'
  end

  Brand.with_shoes.each do |brand|
    add brand_path(brand.slug), priority: 0.7,
      lastmod: brand.updated_at, changefreq: 'weekly'
  end

  Shoe.ready.each do |shoe|
    add shoe_path(shoe.category.slug, shoe.brand.slug, shoe.slug), priority: 0.5,
      lastmod: shoe.updated_at, changefreq: 'weekly'
  end
end