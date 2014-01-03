_.mixin
  eachSlice: (obj, size, iterator, context) ->
    for i in [0..obj.length] by size
      slice = obj.slice(i, i+size)
      if typeof slice != 'undefined' && slice.length > 0
        iterator.call context, obj.slice(i, i+size), i, obj