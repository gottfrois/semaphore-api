async = require 'async'

module.exports = (project, server)->

  info: (deploy, cb)=>
    @get "projects/#{project}/servers/#{server}/deploys/#{deploy}", cb

  log: (deploy, cb)=>
    @get "projects/#{project}/servers/#{server}/deploys/#{deploy}/log", cb

  stop: (deploy, cb)=>
    @get "projects/#{project}/servers/#{server}/deploys/#{deploy}/stop", cb
