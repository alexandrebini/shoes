module SlugGenerator
  extend ActiveSupport::Concern

  def to_slug
    (cleared_name - cleared_colors + cleared_colors).compact.uniq.join(' ')
  end

  private
  def cleared_name
    name.split(' ').map do |word|
      cleared_word(word)
    end.compact.uniq.each_slice(2).map do |words|
      cleared_word(words.join ' ')
    end.compact.uniq
  end

  def cleared_colors
    if self.colors
      colors.map{ |color| cleared_word(color.name) }
    else
      []
    end.compact.uniq
  end

  def cleared_word(word)
    case
    when category && category.against(word) then nil
    when brand && brand.against(word) then nil
    else word
    end
  end
end