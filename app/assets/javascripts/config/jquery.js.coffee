do ($) ->
  $.fn.insertAt = (index, element) ->
    lastIndex
    if (index <= 0)
      return this.prepend(element)
    lastIndex = this.children().size()
    if (index >= lastIndex)
      return this.append(element)
    return $(this.children()[index - 1]).after(element)