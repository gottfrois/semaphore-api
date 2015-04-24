async = require 'async'

module.exports = (cb)->
  @get 'projects/', cb
