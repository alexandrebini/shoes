module SlugGenerator
  extend ActiveSupport::Concern

  def to_slug
    (cleared_name - cleared_colors + cleared_colors).compact.uniq.join(' ')
  end

  private
  def cleared_name
    words = name.split(' ').map do |word|
      cleared_word(word)
    end.compact.uniq

    slice_size = words.size > 2 ? 2 : words.size
    words.permutation.to_a.flatten.each_slice(slice_size) do |slice|
      words -= slice if cleared_word(slice.join ' ').nil?
    end

    words
  end

  def cleared_colors
    self.colors.map(&:name)
  end

  def cleared_word(word)
    case
    when Category.matches(word) then nil
    when Brand.matches(word) then nil
    when Palette.matches(word) then nil
    when Color.matches(word) then nil
    else word
    end
  end
end