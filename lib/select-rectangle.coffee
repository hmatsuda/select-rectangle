{Range} = require 'atom'
module.exports =
  activate: ->
    atom.workspaceView.command "select-rectangle:select", '.editor', ->
      editor = atom.workspace.activePaneItem
      select(editor)
    atom.workspaceView.command "select-rectangle:copy", '.editor', ->
      editor = atom.workspace.activePaneItem
      copy(editor)
    atom.workspaceView.command "select-rectangle:cut", '.editor', ->
      editor = atom.workspace.activePaneItem
      cut(editor)
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

copy = (editor) ->
  selectionRange = editor.getSelection().getBufferRange()
  rectangleRanges = _getRangesOfRectangle(selectionRange)
  editor.setSelectedBufferRanges(rectangleRanges)

  editor.copySelectedText()
  editor.setCursorBufferPosition [
    selectionRange.end.row
    selectionRange.end.column
  ]

cut = (editor) ->
  selectionRange = editor.getSelection().getBufferRange()
  rectangleRanges = _getRangesOfRectangle(selectionRange)
  editor.setSelectedBufferRanges(rectangleRanges)

  editor.cutSelectedText()

  editor.setCursorBufferPosition [
    selectionRange.end.row
    selectionRange.start.column
  ]

replaceWithBlank = (editor) ->
  selectionRange = editor.getSelection().getBufferRange()
  rectangleRanges = _getRangesOfRectangle(selectionRange)
  editor.setSelectedBufferRanges(rectangleRanges)

  editor.copySelectedText()
  blankText = _createBlankTextBy(_getLengthOf(selectionRange))
  editor.insertText(blankText)

  editor.setCursorBufferPosition [
    selectionRange.end.row
    selectionRange.end.column
  ]

insertBlank = (editor) ->
  selectionRange = editor.getSelection().getBufferRange()
  rectangleRanges = _getRangesOfRectangle(selectionRange)
  editor.setSelectedBufferRanges(rectangleRanges)

  editor.transact ->
    blankText = _createBlankTextBy(_getLengthOf(selectionRange))
    for range in rectangleRanges
      selectedText = editor.getTextInBufferRange(range)
      editor.setTextInBufferRange(range, "#{blankText}#{selectedText}")

  editor.setCursorBufferPosition [
    selectionRange.end.row
    selectionRange.end.column
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
