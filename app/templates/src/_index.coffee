{EventEmitter}  = require 'events'
debug           = require('debug')('<%= appname %>:index')

class <%= classPrefix %> extends EventEmitter
  constructor: ->

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  onMessage: (message={}) =>
    { payload } = message
    debug 'on message', payload

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options

  start: (device) =>
    debug 'started'
    @onConfig device

module.exports = <%= classPrefix %>
