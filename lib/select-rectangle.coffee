SelectRectangleView = require './select-rectangle-view'
module.exports =
  
  activate: (state) ->
    atom.commands.add 'atom-text-editor', "select-rectangle:select", =>
      editor = atom.workspace.getActiveTextEditor()
      @createSelectRectangleView().select(editor)
    atom.commands.add 'atom-text-editor', "select-rectangle:clear", =>
      editor = atom.workspace.getActiveTextEditor()
      @createSelectRectangleView().clear(editor)
    atom.commands.add 'atom-text-editor', "select-rectangle:open", =>
      editor = atom.workspace.getActiveTextEditor()
      @createSelectRectangleView().open(editor)

  createSelectRectangleView: ->
    unless @selectRectangleView?
      @selectRectangleView = new SelectRectangleView()
    @selectRectangleView
