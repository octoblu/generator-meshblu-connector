meshblu  = require 'meshblu'
{Plugin} = require './index'

Connector = (config) ->
  conx = meshblu.createConnection
    server : config.server
    port   : config.port
    uuid   : config.uuid
    token  : config.token

  consoleError = (error) ->
    console.error error.message
    console.error error.stack

  process.on 'uncaughtException', consoleError
  conx.on 'notReady', consoleError
  conx.on 'error', consoleError

  plugin = new Plugin();

  conx.on 'ready', ->
    conx.whoami uuid: config.uuid, (device) ->
      plugin.setOptions device.options
      conx.update
        uuid:          config.uuid,
        token:         config.token,
        messageSchema: plugin.messageSchema,
        optionsSchema: plugin.optionsSchema,
        options:       plugin.options

  conx.on 'message', ->
    try
      plugin.onMessage arguments...
    catch error
      consoleError error

  conx.on 'config', ->
    try
      plugin.onConfig arguments...
    catch error
      consoleError error

  plugin.on 'message', (message) ->
    conx.message message

  plugin.on 'error', consoleError

module.exports = Connector;
