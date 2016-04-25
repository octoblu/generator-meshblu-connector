{EventEmitter}  = require 'events'
debug           = require('debug')('<%= appname %>:index')

class <%= classPrefix %> extends EventEmitter
  constructor: ->
    debug '<%= classPrefix %> constructed'

  close: (callback) =>
    debug 'on close'
    callback()

  onMessage: (message) =>
    debug 'onMessage', topic: message.topic

  onConfig: (config) =>
    debug 'on config', @device.uuid

  start: (@device) =>
    debug 'started', @device.uuid

module.exports = <%= classPrefix %>
