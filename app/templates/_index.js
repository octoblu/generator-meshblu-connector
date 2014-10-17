'use strict';
var util = require('util');
var EventEmitter = require('events').EventEmitter;

var MESSAGE_SCHEMA = {
  type: 'object',
  properties: {
    exampleBoolean: {
      type: 'boolean',
      required: true
    },
    exampleString: {
      type: 'string',
      required: true
    }
  }
};

var OPTIONS_SCHEMA = {
  type: 'object',
  properties: {
    firstExampleOption: {
      type: 'string',
      required: true
    }
  }
};

function Plugin(){
  this.options = {};
  this.messageSchema = MESSAGE_SCHEMA;
  this.optionsSchema = OPTIONS_SCHEMA;
  return this;
}
util.inherits(Plugin, EventEmitter);

Plugin.prototype.onMessage = function(message){
  var payload = message.payload;
  this.emit('message', {devices: ['*'], topic: 'echo', payload: payload});
};

Plugin.prototype.onConfig = function(device){
  self.setOptions(device.options||{});
};

Plugin.prototype.setOptions = function(options){
  this.options = options;
};

module.exports = {
  messageSchema: MESSAGE_SCHEMA,
  optionsSchema: OPTIONS_SCHEMA,
  Plugin: Plugin
};
