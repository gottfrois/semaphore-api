async = require 'async'

module.exports = (project, cb)->

  info: (branch, build, cb)=>
    @get "projects/#{project}/#{branch}/builds/#{build}", cb

  log: (branch, build, cb)=>
    @get "projects/#{project}/#{branch}/builds/#{build}/log", cb

  rebuild: (branch, build, cb)=>
    @post "projects/#{project}/#{branch}/build", {}, cb

  launch: (branch, build, commit_sha, cb)=>
    @post "projects/#{project}/#{branch}/build", { commit_sha: commit_sha }, cb

  stop: (branch, build, cb)=>
    @post "projects/#{project}/#{branch}/builds/#{build}/stop", {}, cb

  deploy: (branch, build, server, cb)=>
    @post "projects/#{project}/#{branch}/builds/#{build}/deploy/#{server}", {}, cb
