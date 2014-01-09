module Matcher
  extend ActiveSupport::Concern

  def against(name)
    matchers = (matchers.to_a + default_matchers).compact.uniq
    matchers.each do |matcher|
      if name =~ Regexp.new(matcher, Regexp::IGNORECASE)
        return self.name
      end
    end
    return nil
  end

  def default_matchers
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
    def against(name)
      all.each do |record|
        return record.name if record.against(name)
      end
      return nil
    end
  end
end