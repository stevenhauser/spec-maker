{WorkspaceView} = require 'atom'
SpecMaker = require '../lib/spec-maker'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SpecMaker", ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('spec-maker')

  describe 'creating new specs', ->

    it 'creates a new spec for the current file', ->

    it 'uses user settings to name the spec file', ->

    it 'uses user settings to place the spec file', ->

  describe 'opening existing specs', ->

    it 'opens the spec for the current file', ->

    it 'uses user settings to open the spec file', ->
