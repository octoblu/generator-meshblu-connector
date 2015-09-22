Connector = require './connector'
MeshbluConfig = require 'meshblu-config'
meshbluConfig = new MeshbluConfig {}

connector = new Connector meshbluConfig.toJSON()

connector.on 'error', (error) ->
  console.error error.toString()
  console.error error.stack if error?.stack?

connector.run()
