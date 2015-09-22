'use strict';
var Connector     = require('./connector');
var MeshbluConfig = require('meshblu-config');
var meshbluConfig = new MeshbluConfig({});

var connector = new Connector(meshbluConfig.toJSON());

connector.on('error', function(error) {
  console.error(error.toString());
  if(error && error.stack){
    console.error(error.stack);
  }
});

connector.run();
