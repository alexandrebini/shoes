module Crawler
  module ClassMethods
    def const_missing(const)
      if :Worker == const && @worker_class.nil?
        brand = self.instance.send(self.crawler_options[:brand])
        @worker_class_name = "#{ self }::Worker"

        self.const_set(:Worker, Class.new(Crawler::Worker) do
          include Sidekiq::Worker
          sidekiq_options retry: false, unique: :all, queue: brand.slug

          class_eval do
            def self.class_name
             self.to_s
            end
          end
        end)
      else
        super(const)
      end
    end

    def start!
      self.instance.start!
    end
  end
end