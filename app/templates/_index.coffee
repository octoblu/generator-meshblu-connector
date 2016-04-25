{EventEmitter2} = require 'eventemitter2'
debug           = require('debug')('<%= appname %>:index')

class <%= classPrefix %> extends EventEmitter2
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
