http        = require 'scoped-http-client'
async       = require 'async'
querystring = require 'querystring'

class Semaphore
  constructor: (@logger, @options) ->
    @requestQueue = async.queue (task, cb)=>
      task.run(cb)
    , @_opt('concurrentRequests')

  withOptions: (specialOptions) ->
    newOpts = {}
    newOpts[k] = v for k,v of @options
    newOpts[k] = v for k,v of specialOptions
    g = new @constructor @logger, newOpts
    g.requestQueue = @requestQueue
    g

  request: (verb, url, data, cb)->
    unless cb?
      [cb, data] = [data, {}]

    data ?= {}
    data.auth_token = @_opt('authToken')

    url_api_base = @_opt('apiRoot')

    if url[0..3] isnt 'http'
      url = "/#{url}" unless url[0] is "/"
      url = "#{url_api_base}#{url}"

    url += "?#{querystring.stringify(data)}" if data?
    req = http.create(url)
    args = []
    args.push JSON.stringify(data) if data?
    args.push "" if verb is 'DELETE' and not data?

    task = run: (cb) ->
      req[verb.toLowerCase()](args...) cb
    @requestQueue.push task, (err, res, body)=>

      if err?
        return @_errorHandler
          statusCode: res?.statusCode
          body: res?.body
          error: err

      try
        responseData = JSON.parse body if body
      catch e
        return @_errorHandler
          statusCode: res.statusCode
          body: body
          error: "Could not parse response: #{body}"

      if 200 <= res.statusCode < 300
        cb(responseData)
      else
        @_errorHandler
          statusCode: res.statusCode
          body: body
          error: responseData.message

  get: (url, data, cb)->
    @request 'GET', url, data, cb

  post: (url, data, cb)->
    @request 'POST', url, data, cb

  handleErrors: (callback)->
    @options.errorHandler = callback

  projects: require './projects'
  servers: require './servers'
  deploys: require './deploys'
  branches: require './branches'
  builds: require './builds'

  _loggerErrorHandler: (response)->
    message = response.error
    message = "#{response.statusCode} #{message}" if response.statusCode?
    @logger.error(message)

  _errorHandler: (response)->
    @options.errorHandler?(response)
    @_loggerErrorHandler(response)

  _opt: (optName)->
    @options ?= {}
    @options[optName] ? @_optFromEnv(optName)

  _optFromEnv: (optName)->
    switch optName
      when 'authToken'
        process.env.HUBOT_SEMAPHORE_AUTH_TOKEN
      when 'concurrentRequests'
        process.env.HUBOT_CONCURRENT_REQUESTS ? 20
      when 'apiRoot'
        process.env.HUBOT_SEMAPHORE_API ? 'https://semaphoreci.com/api/v1'
      else null

module.exports = semaphore = (robot, options = {})->
  new Semaphore(robot.logger, options)

semaphore[method] = func for method,func of Semaphore.prototype

semaphore.logger =
  error: (msg)->
    console.error "ERROR: #{msg}"
  debug: ->

semaphore.requestQueue = async.queue (task, cb)=>
  task.run(cb)
, process.env.HUBOT_CONCURRENT_REQUESTS ? 20
