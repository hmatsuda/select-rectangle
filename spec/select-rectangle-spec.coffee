{Range, Point} = require 'atom'
SelectRectangle = require '../lib/select-rectangle'

describe "SelectRectangle", ->
  [workspaceElement, activationPromise, editor] = []
  
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open('test.txt')
    atom.packages.activatePackage('select-rectangle')
      

  describe "when rectangle are selected", ->
    it "selects each line of rectangle area", ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(editor)
      editor.setSelectedBufferRange([[0, 3], [2, 6]])
      
      atom.commands.dispatch workspaceElement, "select-rectangle:select"
      
      expect(editor.getSelectedBufferRanges()).toEqual [
          new Range([0, 3], [0, 6])
          new Range([1, 3], [1, 6])
          new Range([2, 3], [2, 6])
      ]
  
    it "replaces rectangle area of selected lines with blank", ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(editor)
      editor.setSelectedBufferRange([[0, 3], [2, 6]])
      atom.commands.dispatch workspaceElement, "select-rectangle:select"
      atom.commands.dispatch workspaceElement, "select-rectangle:clear"
      
      expect(editor.getTextInBufferRange([[0, 0], [2, 9]])).toBe """
        aaa   ccc
        aaa   ccc
        aaa   ccc
      """
      expect(atom.clipboard.read()).toBe """
        bbb
        bbb
        bbb
      """
      expect(editor.getCursorBufferPosition()).toEqual new Point(2, 6)
  
    it "adds blank into area of selected lines", ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(editor)
      editor.setSelectedBufferRange([[0, 3], [2, 6]])
      atom.commands.dispatch workspaceElement, "select-rectangle:select"
      atom.commands.dispatch workspaceElement, "select-rectangle:open"
      
      expect(editor.getTextInBufferRange([[0, 0], [2, 12]])).toBe """
        aaa   bbbccc
        aaa   bbbccc
        aaa   bbbccc
      """
      
      expect(editor.getCursorBufferPosition()).toEqual new Point(2, 6)
  
    it "deselects each line of rectangle area", ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(editor)
      editor.setSelectedBufferRange([[0, 3], [2, 6]])
      atom.commands.dispatch workspaceElement, "select-rectangle:select" # select
      atom.commands.dispatch workspaceElement, "select-rectangle:select" # deselect
      
      expect(editor.getSelectedBufferRanges()).toEqual [
          new Range([0, 3], [2, 6])
      ]
