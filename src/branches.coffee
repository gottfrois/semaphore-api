async = require 'async'

module.exports = (project, cb)->
  if cb?
    @get "projects/#{project}/branches", cb
  else
    status: (branch, cb)=>
      @get "projects/#{project}/#{branch}/status", cb

    history: (branch, opts, cb)=>
      [opts, cb] = [{}, opts] unless cb?
      opts.page ?= 1

      @get "projects/#{project}/#{branch}", opts, cb
