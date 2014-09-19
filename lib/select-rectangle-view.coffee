{View, Range} = require 'atom'

module.exports =
class SelectRectangleView extends View
  
  @content: ->
    @div class: 'select-rectangle-package overlay from-top', =>
      @div "Please select-rectangle at first!", class: "message"

  initialize: (serializeState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    
  destroy: ->

  select: (editor) ->
    if editor.getSelectedBufferRanges().length is 1
      selectionRange = editor.getSelection().getBufferRange()
      rectangleRanges = @_getRangesOfRectangle(selectionRange)
      editor.setSelectedBufferRanges(rectangleRanges)
    else
      ranges = editor.getSelectedBufferRanges()
      editor.setSelectedBufferRange([ranges[0].start, ranges[ranges.length - 1].end])
    
  replaceWithBlank: (editor) ->
    if editor.getSelectedBufferRanges().length is 1
      atom.beep()
    else
      rectangleRanges = editor.getSelectedBufferRanges()

      editor.copySelectedText()
      blankText = @_createBlankTextBy(@_getLengthOf(rectangleRanges[0]))
      editor.insertText(blankText)

      editor.setCursorBufferPosition [
        rectangleRanges[rectangleRanges.length - 1].end.row
        rectangleRanges[rectangleRanges.length - 1].end.column
      ]
    
  addBlank: (editor) ->
    if editor.getSelectedBufferRanges().length is 1
      atom.beep()
    else
      rectangleRanges = editor.getSelectedBufferRanges()
      blankText = @_createBlankTextBy(@_getLengthOf(rectangleRanges[0]))

      editor.transact ->
        for range in rectangleRanges
          selectedText = editor.getTextInBufferRange(range)
          editor.setTextInBufferRange(range, "#{blankText}#{selectedText}")

      editor.setCursorBufferPosition [
        rectangleRanges[rectangleRanges.length - 1].end.row
        rectangleRanges[rectangleRanges.length - 1].end.column
      ]


  _getRangesOfRectangle: (selectionRange) ->
    for row in [selectionRange.start.row..selectionRange.end.row]
      new Range(
        [row, selectionRange.start.column]
        [row, selectionRange.end.column]
        )

  _getLengthOf: (selectionRange) ->
    selectionRange.end.column - selectionRange.start.column

  _createBlankTextBy: (length) ->
    (" " for i in [0...length]).join("")
