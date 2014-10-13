var util = require('util');
var EventEmitter = require('events').EventEmitter;

function Plugin(){
  return this;
}
util.inherits(Plugin, EventEmitter);

Plugin.prototype.onMessage = function(message){
  var data = message.message || message.payload;
  this.emit('message', {devices: ['*'], topic: 'echo', payload: data});
};

module.exports = {
  Plugin: Plugin
};
