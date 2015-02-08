SpecMaker = require '../lib/spec-maker'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SpecMaker", ->

  activeEditor = ->
    atom.workspace.getActiveTextEditor()

  activeEditorView = ->
    atom.views.getView(activeEditor())

  workspaceView = ->
    atom.views.getView(atom.workspace)

  triggerOpenEvent = ->
    atom.commands.dispatch(
      activeEditorView(),
      'spec-maker:open-or-create-spec'
    )

  openFile = (file = 'lib/sample.js') ->
    atom.workspace.open(file)

  # Why can't I use `jasmine.any(Object)`?!?!?
  defaultOpts = ->
    { split: 'right' }


  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('spec-maker')
    waitsForPromise ->
      openFile()
    runs ->
      jasmine.attachToDOM(workspaceView())
      spyOn(atom.workspace, 'open').andCallThrough()


  describe 'creating and opening new specs', ->

    it 'creates/opens a new spec for the current file', ->
      triggerOpenEvent()
      expect(atom.workspace.open).toHaveBeenCalledWith(
        'spec/sample-spec.js',
        defaultOpts()
      );


  describe 'returning from a spec to the source file', ->

    it 'returns to the source file for the spec', ->
      waitsForPromise ->
        openFile('spec/some-path/sample-spec.js')
      runs ->
        atom.config.set('spec-maker.houseOfPane', 'none')
        triggerOpenEvent()
        expect(atom.workspace.open).toHaveBeenCalledWith(
          'lib/some-path/sample.js',
          undefined
        )


  describe 'user suffix and location settings', ->

    it 'uses user settings to name the spec file', ->
      atom.config.set('spec-maker.specSuffix', '.specification')
      triggerOpenEvent()
      expect(atom.workspace.open).toHaveBeenCalledWith(
        'spec/sample.specification.js',
        defaultOpts()
      )

    it 'uses user settings to place the spec file', ->
      atom.config.set('spec-maker.specLocation', 'tests')
      triggerOpenEvent()
      expect(atom.workspace.open).toHaveBeenCalledWith(
        'tests/sample-spec.js',
        defaultOpts()
      )

    it 'uses user settings to place the spec file from source files', ->
      waitsForPromise ->
        openFile('source/js/some-path/sample.js')
      runs ->
        atom.config.set('spec-maker.srcLocation', 'source/js')
        triggerOpenEvent()
        expect(atom.workspace.open).toHaveBeenCalledWith(
          'spec/some-path/sample-spec.js',
          defaultOpts()
        )


  describe 'user settings pane settings', ->

    it 'opens in a specified pane', ->
      atom.config.set('spec-maker.houseOfPane', 'left')
      triggerOpenEvent()
      expect(atom.workspace.open).toHaveBeenCalledWith(
        'spec/sample-spec.js',
        { split: 'left' }
      )

    it 'opens in no pane', ->
      atom.config.set('spec-maker.houseOfPane', 'none')
      triggerOpenEvent()
      expect(atom.workspace.open).toHaveBeenCalledWith(
        'spec/sample-spec.js',
        undefined
      )
