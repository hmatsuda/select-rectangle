{WorkspaceView, Range, Point} = require 'atom'
SelectRectangle = require '../lib/select-rectangle'

describe "SelectRectangle", ->
  [activationPromise, editor, editorView] = []

  clear = (callback) ->
    editorView.trigger "select-rectangle:clear"
    waitsForPromise -> activationPromise
    runs(callback)
  
  open = (callback) ->
    editorView.trigger "select-rectangle:open"
    waitsForPromise -> activationPromise
    runs(callback)


  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    activationPromise = atom.packages.activatePackage('select-rectangle')

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    editor.setText """
      aaabbbccc
      aaabbbccc
      aaabbbccc
    """
    
    editor.setSelectedBufferRange([[0, 3], [2, 6]])
    
    editorView.trigger "select-rectangle:select"


  describe "when rectangle are selected", ->
    it "selects each line of rectangle area", ->
      expect(editor.getSelectedBufferRanges()).toEqual [
          new Range([0, 3], [0, 6])
          new Range([1, 3], [1, 6])
          new Range([2, 3], [2, 6])
      ]

    
    it "replaces rectangle area of selected lines with blank", ->
      clear ->
        expect(editor.getText()).toBe """
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
      open ->
        expect(editor.getText()).toBe """
          aaa   bbbccc
          aaa   bbbccc
          aaa   bbbccc
        """
    
        expect(editor.getCursorBufferPosition()).toEqual new Point(2, 6)


    it "deselects each line of rectangle area", ->
      editorView.trigger "select-rectangle:select"
      expect(editor.getSelectedBufferRanges()).toEqual [
          new Range([0, 3], [2, 6])
      ]
