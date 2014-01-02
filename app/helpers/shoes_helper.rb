module ShoesHelper
  def shoe(shoe, style: :thumb, klass: '')
    return if shoe.blank?
    content_tag :div, class: "shoes--#{ style } #{ klass }" do
      content_tag :div, class: 'l-middle' do
        image_tag shoe.photo.url(style), size: shoe.photo.image_size(style)
      end
    end
  end
end