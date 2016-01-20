config = (prop) ->
  atom.config.get("spec-maker.#{prop}")

removeLeadingSlashes = (path) ->
  path.replace(/^\/+/, '')

removeTrailingSlashes = (path) ->
  path.replace(/\/+$/, '')

ensureTrailingSlashes = (path) ->
  removeTrailingSlashes(path) + '/'

getCurrentPath = ->
  atom.workspace.getActiveTextEditor()?.getPath() or ''

getRelPath = (path) ->
  path.replace(atom.project.getPaths()[0], '')

warnOfUnreplacement = ->
  console.warn [
    "Spec Maker: no replacement made between"
    "`srcLocation` (#{config('srcLocation')}) and"
    "`specLocation` (#{config('specLocation')})."
    "Are you sure your config is correct?"
  ].join(" ")

replaceSrcLocWithSpecLoc = (path) ->
  fromPath   = config('srcLocation')
  toPath     = config('specLocation')
  isPathSpec = new RegExp(toPath).test(path)
  [fromPath, toPath] = [toPath, fromPath] if isPathSpec

  origPath = path
  newPath = path.replace(
    ensureTrailingSlashes(fromPath),
    ensureTrailingSlashes(toPath)
  )
  warnOfUnreplacement() if newPath is origPath
  newPath

addSuffix = (path) ->
  specSuffix = config('specSuffix')
  if new RegExp(specSuffix).test(path)
    path.replace(specSuffix, '')
  else
    path.replace('.', specSuffix + '.')

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
  atom.workspace.open path, opts

module.exports =

  activate: (state) ->
    atom.commands.add 'atom-text-editor',
      'spec-maker:open-or-create-spec': (event) ->
        createSpec()

  deactivate: ->

  serialize: ->

  config:
    # What to append to the source file name to turn it into a spec file.
    # ie `my-app-file.js` -> `my-app-file-spec.js`
    specSuffix:
      type: 'string'
      default: ''
    # Where the specs live
    # ie `lib/views/my-app-view.js` -> `spec/views/my-app-view-spec.js`
    specLocation:
      type: 'string'
      default: ''
    # Where the source code lives
    # ie `lib/my-app-file.js` or `src/my-app-file.js`
    srcLocation:
      type: 'string'
      default: ''
    # Which pane a spec is opened into.
    # ie `left`, `right`, or `none`
    # Currently Atom only seems to support left/right but not above/below,
    # at least in the `open` API, so that will suffice for now.
    # Also radio buttons don't seem to be supported yet so this is a string.
    houseOfPane:
      type: 'string'
      default: 'right'
