{View, Range} = require 'atom'

module.exports =
class SelectRectangleView extends View
  originalSelectionRange: null
  
  @content: ->
    @div class: 'select-rectangle overlay from-top'

  initialize: (serializeState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  select: (editor) ->
    @subscribe atom.workspace.activePaneItem.getSelection(), 'destroyed', =>
      @originalSelectionRange = null

    if @originalSelectionRange is null
      @originalSelectionRange = selectionRange = editor.getSelection().getBufferRange()

      rectangleRanges = @_getRangesOfRectangle(selectionRange)
      editor.setSelectedBufferRanges(rectangleRanges)
    else
      editor.setSelectedBufferRange(@originalSelectionRange)
      @originalSelectionRange = null
    

  replaceWithBlank: (editor) ->
    rectangleRanges = editor.getSelectedBufferRanges()

    editor.copySelectedText()
    blankText = @_createBlankTextBy(@_getLengthOf(rectangleRanges[0]))
    editor.insertText(blankText)

    editor.setCursorBufferPosition [
      rectangleRanges[rectangleRanges.length - 1].end.row
      rectangleRanges[rectangleRanges.length - 1].end.column
    ]

    @originalSelectionRange = null
    
  insertBlank: (editor) ->
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
    
    @originalSelectionRange = null


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
