{Range} = require 'atom'
module.exports =
  activate: ->
    atom.workspaceView.command "select-rectangle:select", '.editor', ->
      editor = atom.workspace.activePaneItem
      select(editor)
    atom.workspaceView.command "select-rectangle:replace-with-blank", '.editor', ->
      editor = atom.workspace.activePaneItem
      replaceWithBlank(editor)
    atom.workspaceView.command "select-rectangle:insert-blank", '.editor', ->
      editor = atom.workspace.activePaneItem
      insertBlank(editor)

select = (editor) ->
  selectionRange = editor.getSelection().getBufferRange()
  rectangleRanges = _getRangesOfRectangle(selectionRange)
  editor.setSelectedBufferRanges(rectangleRanges)

replaceWithBlank = (editor) ->
  rectangleRanges = editor.getSelectedBufferRanges()

  editor.copySelectedText()
  blankText = _createBlankTextBy(_getLengthOf(rectangleRanges[0]))
  editor.insertText(blankText)

  editor.setCursorBufferPosition [
    rectangleRanges[rectangleRanges.length - 1].end.row
    rectangleRanges[rectangleRanges.length - 1].end.column
  ]

insertBlank = (editor) ->
  rectangleRanges = editor.getSelectedBufferRanges()

  editor.transact ->
    blankText = _createBlankTextBy(_getLengthOf(rectangleRanges[0]))
    for range in rectangleRanges
      selectedText = editor.getTextInBufferRange(range)
      editor.setTextInBufferRange(range, "#{blankText}#{selectedText}")

  editor.setCursorBufferPosition [
    rectangleRanges[rectangleRanges.length - 1].end.row
    rectangleRanges[rectangleRanges.length - 1].end.column
  ]

_getRangesOfRectangle = (selectionRange) ->
  for row in [selectionRange.start.row..selectionRange.end.row]
    new Range(
      [row, selectionRange.start.column]
      [row, selectionRange.end.column]
      )

_getLengthOf = (selectionRange) ->
  selectionRange.end.column - selectionRange.start.column

_createBlankTextBy = (length) ->
  (" " for i in [0...length]).join("")
