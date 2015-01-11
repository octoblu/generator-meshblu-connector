'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('<%= _.slugify(connectorName) %>')

MESSAGE_SCHEMA =
  type: 'object'
  properties:
    exampleBoolean:
      type: 'boolean'
      required: true
    exampleString:
      type: 'string'
      required: true

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    firstExampleOption:
      type: 'string'
      required: true

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    payload = message.payload;
    response =
      devices: ['*']
      topic: 'echo'
      payload: payload
    this.emit 'message', response

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
