'use strict';
var Connector     = require('./connector');
var _             = require('lodash');
var MeshbluConfig = require('meshblu-config');
var meshbluConfig = new MeshbluConfig({});

var connector = new Connector(meshbluConfig.toJSON());

connector.on('error', function(error) {
  if(!error){
    console.error('an unknown error occured');
    return;
  }
  if(_.isPlainObject(error)){
    console.error(error);
    return;
  }
  console.error(error.toString());
  if(error.stack){
    console.error(error.stack);
  }
});

connector.run();
