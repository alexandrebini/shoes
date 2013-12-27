module Crawler
  module ActMacro
    # For use this lib you should implement the following methods:
    #
    # store():                 the store model
    # pages_urls(page):         this method receive a nokogiri page and return
    #                           a list of urls to be crawled. This is used for
    #                           listing pages.
    # shoes_urls(page):    this method receive a nokogiri page and return
    #                           a list of shoes urls do be crawled. This is
    #                           used for shoes (show) pages.
    # parse_shoe(options): this method receive a nokogiri page and the
    #                           image src url. This method must create a new shoe.
    # parse_image(options):     this method receive a nokogiri page and the page
    #                           url. This method must return the shoe image url.
    def acts_as_crawler(options={})
      default_options = {
        store: :store,
        pages_urls: :pages_urls,
        shoes_urls: :shoes_urls,
        parse_shoe: :parse_shoe,
        parse_image: :parse_image
      }
      class_attribute :crawler_options
      self.crawler_options = default_options.merge(options)

      include Singleton
      include InstanceMethods
      extend  ClassMethods
    end
  end
end