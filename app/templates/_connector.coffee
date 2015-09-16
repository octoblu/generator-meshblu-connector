meshblu  = require 'meshblu'
{EventEmitter} = require 'events'
{Plugin} = require './index.coffee'

class Connector extends EventEmitter
  constructor: (@config={}) ->
    process?.on 'uncaughtException', (error) =>
      @emitError error
      process?.exit 1

  createConnection: =>
    @conx = meshblu.createConnection
      server : @config.server
      port   : @config.port
      uuid   : @config.uuid
      token  : @config.token

    @conx.on 'notReady', @emitError
    @conx.on 'error', @emitError

    @conx.on 'ready', @onReady
    @conx.on 'message', @onMessage
    @conx.on 'config', @onConfig

  onConfig: (device) =>
    @emit 'config', device
    try
      @plugin.onConfig arguments...
    catch error
      @emitError error

  onMessage: (message) =>
    @emit 'message.recieve', message
    try
      @plugin.onMessage arguments...
    catch error
      @emitError error

  onReady: =>
    @conx.whoami uuid: @config.uuid, (device) =>
      @plugin.setOptions device.options
      @conx.update
        uuid:          @config.uuid,
        token:         @config.token,
        messageSchema: @plugin.messageSchema,
        optionsSchema: @plugin.optionsSchema,
        options:       @plugin.options
        initializing:  false

  run: =>
    @plugin = new Plugin();
    @createConnection()
    @plugin.on 'data', (data) =>
      @emit 'data.send', data
      @conx.data data

    @plugin.on 'error', @emitError

    @plugin.on 'update', (properties) =>
      @emit 'update', properties
      @conx.update properties

    @plugin.on 'message', (message) =>
      @emit 'message.send', message
      @conx.message message

  emitError: (error) =>
    @emit 'error', error

module.exports = Connector;
