SelectRectangleView = require './select-rectangle-view'

module.exports =
  selectRectangleView: null
  
  activate: (state) ->
    atom.workspaceView.command "select-rectangle:select", '.editor', ->
      editor = atom.workspace.activePaneItem
      new SelectRectangleView(state.selectRectangleViewState).select(editor)
    atom.workspaceView.command "select-rectangle:replace-with-blank", '.editor', ->
      editor = atom.workspace.activePaneItem
      new SelectRectangleView(state.selectRectangleViewState).replaceWithBlank(editor)
    atom.workspaceView.command "select-rectangle:insert-blank", '.editor', ->
      editor = atom.workspace.activePaneItem
      new SelectRectangleView(state.selectRectangleViewState).insertBlank(editor)
