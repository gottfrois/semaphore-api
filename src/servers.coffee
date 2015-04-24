async = require 'async'

module.exports = (project, cb)->
  if cb?
    @get "projects/#{project}/servers", cb
  else
    status: (server, cb)=>
      @get "projects/#{project}/servers/#{server}/status", cb

    history: (server, opts, cb)=>
      [opts, cb] = [{}, opts] unless cb?
      opts.page ?= 1

      @get "projects/#{project}/servers/#{server}", opts, cb
