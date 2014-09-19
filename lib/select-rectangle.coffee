SelectRectangleView = require './select-rectangle-view'
module.exports =
  
  activate: (state) ->
    atom.workspaceView.command "select-rectangle:select", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().select(editor)
    atom.workspaceView.command "select-rectangle:replace-with-blank", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().replaceWithBlank(editor)
    atom.workspaceView.command "select-rectangle:add-blank", '.editor', =>
      editor = atom.workspace.activePaneItem
      @createSelectRectangleView().addBlank(editor)

  createSelectRectangleView: ->
    unless @selectRectangleView?
      @selectRectangleView = new SelectRectangleView()
    @selectRectangleView
