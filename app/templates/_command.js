'use strict';
var config = require('./meshblu.json');
var Connector = require('./connector');

var connector = new Connector(config);

connector.on('error', function(error) {
  console.error(error);
});

connector.run();
