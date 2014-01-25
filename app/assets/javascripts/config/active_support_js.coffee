Array.prototype.toSentence = ->
  wordsConnector = ', '
  lastWordConnector = ' e '
  sentence = undefined

  switch @length
    when 0
      sentence = ''
    when 1
      sentence = @[0]
    when 2
      sentence = @[0] + lastWordConnector + @[1]
    else
      sentence = @slice(0, -1).join(wordsConnector) + lastWordConnector + @[@length - 1]

  sentence