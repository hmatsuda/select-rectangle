{WorkspaceView, Range, Point} = require 'atom'
SelectRectangle = require '../lib/select-rectangle'

describe "SelectRectangle", ->
  [activationPromise, editor, editorView] = []

  copy = (callback) ->
    editorView.trigger "select-rectangle:copy"
    waitsForPromise -> activationPromise
    runs(callback)

  cut = (callback) ->
    editorView.trigger "select-rectangle:cut"
    waitsForPromise -> activationPromise
    runs(callback)

  replaceWithBlank = (callback) ->
    editorView.trigger "select-rectangle:replace-with-blank"
    waitsForPromise -> activationPromise
    runs(callback)

  insertBlank = (callback) ->
    editorView.trigger "select-rectangle:insert-blank"
    waitsForPromise -> activationPromise
    runs(callback)

  select = (callback) ->
    editorView.trigger "select-rectangle:select"
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


  describe "when entire are selected", ->
    it "copies the rectangle area of selected lines", ->
      copy ->
        expect(editor.getText()).toBe """
          aaabbbccc
          aaabbbccc
          aaabbbccc
        """

        expect(atom.clipboard.read()).toBe """
          bbb
          bbb
          bbb
        """

        expect(editor.getCursorBufferPosition()).toEqual new Point(2, 6)

    it "cuts the rectangle area of selected lines", ->
      cut ->
        expect(editor.getText()).toBe """
          aaaccc
          aaaccc
          aaaccc
        """

        expect(atom.clipboard.read()).toBe """
          bbb
          bbb
          bbb
        """

        expect(editor.getCursorBufferPosition()).toEqual new Point(2, 3)

    it "replaces rectangle area of selected lines with blank", ->
      replaceWithBlank ->
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

    it "inserts blank into area of selected lines", ->
      insertBlank ->
        expect(editor.getText()).toBe """
          aaa   bbbccc
          aaa   bbbccc
          aaa   bbbccc
        """

        expect(editor.getCursorBufferPosition()).toEqual new Point(2, 6)


    it "selects each line of rectangle area", ->
      select ->
        expect(editor.getText()).toBe """
          aaabbbccc
          aaabbbccc
          aaabbbccc
        """

        expect(editor.getSelectedBufferRanges()).toEqual [
            new Range([0, 3], [0, 6])
            new Range([1, 3], [1, 6])
            new Range([2, 3], [2, 6])
        ]
