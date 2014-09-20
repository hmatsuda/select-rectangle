SelectRectangleView = require './select-rectangle-view'
module.exports =
  
  activate: (state) ->
    atom.workspaceView.command "select-rectangle:select", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().select(editor)
    atom.workspaceView.command "select-rectangle:clear", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().clear(editor)
    atom.workspaceView.command "select-rectangle:open", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().open(editor)

  createSelectRectangleView: ->
    unless @selectRectangleView?
      @selectRectangleView = new SelectRectangleView()
    @selectRectangleView
