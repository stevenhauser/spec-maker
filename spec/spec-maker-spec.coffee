{WorkspaceView} = require 'atom'
SpecMaker = require '../lib/spec-maker'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SpecMaker", ->

  editorView = null
  editor = null

  triggerOpenEvent = ->
    editorView.trigger 'spec-maker:open-or-create-spec'

  stripProjectPath = (path) ->
    path.replace(atom.project.getPath(), '')

  currentEditorPath = ->
    stripProjectPath atom.workspaceView.getActiveView().editor.getPath()

  openFileAndSetEditors = (file = 'lib/sample.js') ->
    atom.workspaceView.openSync(file)
    editorView = atom.workspaceView.getActiveView()
    {editor} = editorView

  beforeEach ->
    wsv = atom.workspaceView = new WorkspaceView
    wsv.attachToDom()
    # Use `openSync` to facilitate specs w/o promises and `runs`
    spyOn(wsv, 'open').andCallFake(wsv.openSync.bind(wsv))
    waitsForPromise ->
      atom.packages.activatePackage('spec-maker')
    runs ->
      openFileAndSetEditors()

  describe 'creating and opening new specs', ->

    it 'creates/opens a new spec for the current file', ->
      triggerOpenEvent()
      expect(currentEditorPath()).toEqual('/spec/sample-spec.js')

    it 'uses user settings to name the spec file', ->
      atom.config.set('spec-maker.specSuffix', '.specification')
      triggerOpenEvent()
      expect(currentEditorPath()).toEqual('/spec/sample.specification.js')

    it 'uses user settings to place the spec file', ->
      atom.config.set('spec-maker.specLocation', 'tests')
      triggerOpenEvent()
      expect(currentEditorPath()).toEqual('/tests/sample-spec.js')

    it 'uses user settings to place the spec file from source files', ->
      openFileAndSetEditors('source/js/some-path/sample.js')
      atom.config.set('spec-maker.srcLocation', 'source/js')
      triggerOpenEvent()
      expect(currentEditorPath()).toEqual('/spec/some-path/sample-spec.js')
