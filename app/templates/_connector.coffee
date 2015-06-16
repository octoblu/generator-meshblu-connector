meshblu  = require 'meshblu'
{EventEmitter} = require 'events'
{Plugin} = require './index'

class Connector extends EventEmitter
  constructor: (@config={}) ->
    process.on 'uncaughtException', @consoleError

  createConnection: =>
    @conx = meshblu.createConnection
      server : @config.server
      port   : @config.port
      uuid   : @config.uuid
      token  : @config.token

    @conx.on 'notReady', @consoleError
    @conx.on 'error', @consoleError

    @conx.on 'ready', @onReady
    @conx.on 'message', @onMessage
    @conx.on 'config', @onConfig

  onConfig: (device) =>
    @emit 'config', device
    try
      @plugin.onConfig arguments...
    catch error
      @consoleError error

  onMessage: (message) =>
    @emit 'message.recieve', message
    try
      @plugin.onMessage arguments...
    catch error
      @consoleError error

  onReady: =>
    @conx.whoami uuid: @config.uuid, (device) =>
      @plugin.setOptions device.options
      @conx.update
        uuid:          @config.uuid,
        token:         @config.token,
        messageSchema: @plugin.messageSchema,
        optionsSchema: @plugin.optionsSchema,
        options:       @plugin.options

  run: =>
    @plugin = new Plugin();
    @createConnection()
    @plugin.on 'data', (data) =>
      @emit 'data.send', data
      @conx.data data

    @plugin.on 'error', @emitError

    @plugin.on 'message', (message) =>
      @emit 'message.send', message
      @conx.message message

  emitError: (error) =>
    @emit 'error', error

module.exports = Connector;
