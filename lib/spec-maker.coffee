module.exports =

  activate: (state) ->

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
