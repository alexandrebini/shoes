require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'csv'
require 'singleton'

module Crawler
  autoload :UrlOpener,        File.expand_path('../base/url_opener', __FILE__)
  autoload :Worker,           File.expand_path('../base/worker', __FILE__)
  autoload :ActMacro,         File.expand_path('../base/act_macro', __FILE__)
  autoload :ClassMethods,     File.expand_path('../base/class_methods', __FILE__)
  autoload :InstanceMethods,  File.expand_path('../base/instance_methods', __FILE__)

  autoload :Carmensteffens,   File.expand_path('../carmensteffens', __FILE__)
  autoload :Corello,          File.expand_path('../corello', __FILE__)
  autoload :Louloux,          File.expand_path('../louloux', __FILE__)
  autoload :Melissa,          File.expand_path('../melissa', __FILE__)
  autoload :Schutz,           File.expand_path('../schutz', __FILE__)
end