config = require './meshblu.json'
Connector = require './connector'

connector = new Connector config
connector.run()
