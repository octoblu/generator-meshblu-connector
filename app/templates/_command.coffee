_             = require 'lodash'
Connector     = require './connector'
MeshbluConfig = require 'meshblu-config'
meshbluConfig = new MeshbluConfig {}

connector = new Connector meshbluConfig.toJSON()

connector.on 'error', (error) ->
  return console.error 'an unknown error occured' unless error?
  return console.error error if _.isPlainObject error
  console.error error.toString()
  console.error error.stack if error?.stack?

connector.run()
