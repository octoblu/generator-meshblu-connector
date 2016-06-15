#!/usr/bin/env node
'use strict';
require('coffee-script/register');
require('fs-cson/register');

var ConnectorRunner = require('meshblu-connector-runner');
var MeshbluConfig   = require('meshblu-config');

var connectorRunner = new ConnectorRunner({
  connectorPath: __dirname,
  meshbluConfig: new MeshbluConfig().toJSON()
});
connectorRunner.run()
