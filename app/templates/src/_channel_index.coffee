{EventEmitter}  = require 'events'
debug           = require('debug')('<%= appname %>:index')
_                       = require 'lodash'
channelJson             = require '../channel'
schemas                 = require '../optionsSchema'
request                 = require 'request'
OctobluRequestFormatter = require 'octoblu-request-formatter'
format                  = new OctobluRequestFormatter(channelJson)

class <%= classPrefix %> extends EventEmitter
  constructor: ->
    debug '<%= classPrefix %> constructed'

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  onMessage: (message) =>
    return unless message?
    { topic, devices, fromUuid } = message
    return if '*' in devices
    return if fromUuid == @uuid
    debug 'onMessage', { message }
    return if !message.payload.endpoint?

    requestParams = format.processMessage message.payload, {}, @defaultUrlParams

    if @auth.access_token?
      requestParams = @customizeRequest(requestParams)
      debug 'formatted request', requestParams

      @sendRequest requestParams, message
    else
      errorResponse = {
        fromUuid: message.fromUuid
        fromNodeId: message.metadata.flow.fromNodeId
        error: 'Missing access_token!'
      }
      @sendError errorResponse

  saveAuth: () =>
    if @options.host?
      @defaultUrlParams = {
          ':hostname': @options.host
          ':port': @options.port
        }

    if @options.access_token?
      @auth = {
        access_token: @options.access_token
      }

  customizeRequest: (requestParams) =>
    { access_token } = @auth
    requestParams.headers.Authorization = "Bearer " + access_token
    return requestParams

  onConfig: (config) =>
    return unless config?
    debug 'on config', @uuid
    @options = config.options || {}
    @saveAuth()

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    update = _.extend schemas, format.buildSchema()
    update.octoblu ?= {}
    update.octoblu.flow ?= {}
    update.octoblu.flow.forwardMetadata = true

    @emit 'update', update

  sendRequest: (requestParams, message) =>
    debug 'Sending Request'
    { fromUuid, metadata } = message
    request requestParams, (error, response, body) =>
      if error?
          errorResponse = {
            fromUuid: fromUuid
            fromNodeId: metadata.flow.fromNodeId
            error: error
          }
          return @sendError errorResponse
      body = JSON.parse(body)
      response = {
          fromUuid: fromUuid
          fromNodeId: metadata.flow.fromNodeId
          metadata: metadata
          data: body
        }
      @sendResponse response
      debug 'Body: ', body

  sendError: ({fromUuid, fromNodeId, error}) =>
    code = error.code ? 500
    @emit 'message', {
      devices: [fromUuid]
      payload:
        from: fromNodeId
        metadata:
          code: code
          status: code
          error:
            message: error.message ? 'Unknown Error'
    }

  sendResponse: ({fromUuid, fromNodeId, metadata, data}) =>
   @emit 'message', {
     devices: [fromUuid]
     payload:
       from: fromNodeId
       metadata: metadata
       data: data
   }

module.exports = <%= classPrefix %>
