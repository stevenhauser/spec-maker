config = (prop) ->
  atom.config.get("spec-maker.#{prop}")

removeLeadingSlashes = (path) ->
  path.replace(/^\/+/, '')

removeTrailingSlashes = (path) ->
  path.replace(/\/+$/, '')

ensureTrailingSlashes = (path) ->
  removeTrailingSlashes(path) + '/'

getCurrentPath = ->
  atom.workspaceView.getActiveView()?.editor?.getPath() or ''

getRelPath = (path) ->
  path.replace(atom.project.getPath(), '')

warnOfUnreplacement = ->
  console.warn [
    "Spec Maker: no replacement made between"
    "`srcLocation` (#{config('srcLocation')}) and"
    "`specLocation` (#{config('specLocation')})."
    "Are you sure your config is correct?"
  ].join(" ")

replaceSrcLocWithSpecLoc = (path) ->
  origPath = path
  newPath = path.replace(
    ensureTrailingSlashes(config('srcLocation')),
    ensureTrailingSlashes(config('specLocation'))
  )
  warnOfUnreplacement() if newPath is origPath
  newPath

addSuffix = (path) ->
  path.replace('.', config('specSuffix') + '.')

deduceSpecPath = ->
  [
    getCurrentPath
    getRelPath
    replaceSrcLocWithSpecLoc
    removeLeadingSlashes
    addSuffix
  ].reduce ((path, fn) -> fn(path)), ''

createSpec = ->
  path = deduceSpecPath()
  # console.log path
  opts = { split: config('houseOfPane') } unless config('houseOfPane') is 'none'
  atom.workspaceView.open path, opts

module.exports =

  activate: (state) ->
    atom.workspaceView.command 'spec-maker:open-or-create-spec', createSpec

  deactivate: ->

  serialize: ->

  configDefaults:
    # What to append to the source file name to turn it into a spec file.
    # ie `my-app-file.js` -> `my-app-file-spec.js`
    specSuffix: '-spec'
    # Where the specs live
    # ie `lib/views/my-app-view.js` -> `spec/views/my-app-view-spec.js`
    specLocation: 'spec/'
    # Where the source code lives
    # ie `lib/my-app-file.js` or `src/my-app-file.js`
    srcLocation: 'lib/'
    # Which pane a spec is opened into.
    # ie `left`, `right`, or `none`
    # Currently Atom only seems to support left/right but not above/below,
    # at least in the `open` API, so that will suffice for now.
    # Also radio buttons don't seem to be supported yet so this is a string.
    houseOfPane: 'right'
