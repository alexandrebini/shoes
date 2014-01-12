module Matcher
  extend ActiveSupport::Concern

  def matches(name)
    if all_matchers
      all_matchers.each do |matcher|
        if name =~ Regexp.new(matcher, Regexp::IGNORECASE)
          return self.name
        end
      end
    end
    return nil
  end

  private

  def all_matchers
    if @all_matchers.nil?
      @all_matchers = [name]
      @all_matchers += matchers.to_a if respond_to?(:matchers)
      @all_matchers = @all_matchers.map do |name|
        matchers_for(name)
      end.flatten.compact.uniq
    end
    @all_matchers
  end

  def matchers_for(name)
    [
      name,
      name.singularize,
      slug,
      slug.singularize,
      I18n.transliterate(name),
      I18n.transliterate(name.singularize)
    ]
  end

  module ClassMethods
    def matches(name)
      all.each do |record|
        return record.name if record.matches(name)
      end
      return nil
    end
  end
end