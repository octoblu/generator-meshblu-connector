{EventEmitter}  = require 'events'
debug           = require('debug')('<%= appname %>:index')

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
    debug 'onMessage', { topic }

  onConfig: (config) =>
    return unless config?
    debug 'on config', @uuid

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid

module.exports = <%= classPrefix %>
