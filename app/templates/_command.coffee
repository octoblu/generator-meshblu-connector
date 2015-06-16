config = require './meshblu.json'
Connector = require './connector'

connector = new Connector config

connector.on 'error', (error) ->
  console.error error

connector.run()
