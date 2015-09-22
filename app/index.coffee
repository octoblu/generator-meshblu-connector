yeoman = require 'yeoman-generator'
yosay  = require 'yosay'
_      = require 'lodash'

MeshbluConnectorGenerator = yeoman.generators.Base.extend
  constructor: ->
    yeoman.generators.Base.apply this, arguments
    @option 'coffee'

  initializing: ->
    @pkg = require '../package.json'

  prompting: ->
    done = @async()

    @log yosay 'Welcome to the Meshblu Connector generator!'

    prompts = [{
      name: 'safety-dance'
      message: 'This will create the meshblu-connector in the CURRENT DIRECTORY!\n\tPress ctrl+c to quit now, press enter to continue'
    },{
      type: 'input'
      name: 'connectorName'
      message: 'What is the name of your connector?'
      default : _.kebabCase @appname
    }];

    @prompt prompts, (props) =>
      @connectorName = props.connectorName
      done()

  configuring:
    enforceFolderName: ->
      @config.save()

  writing:
    app: ->
      if @options.coffee
        @template '_index.coffee.js', 'index.js'
        @template '_index.coffee', 'index.coffee'
        @copy '_command.coffee.js', 'command.js'
        @copy '_command.coffee', 'command.coffee'
        @copy '_connector.coffee', 'connector.coffee'
        @copy '_connector.coffee.js', 'connector.js'
      else
        @template '_index.js', 'index.js'
        @copy '_command.js', 'command.js'
        @copy '_connector.js', 'connector.js'

      @template '_package.json', 'package.json'
      @template '_appveyor.yml', 'appveyor.yml'
      @template '_travis.yml', '.travis.yml'
      @copy '_gitignore', '.gitignore'
      @copy '_skip-install.js', 'skip-install.js'
      @copy '_npmignore', '.npmignore'
      @copy '_README.md', 'README.md'
      @copy '_LICENSE', 'LICENSE'

  install: ->
    dependencies = ['meshblu', 'meshblu-config', 'lodash', 'debug']
    dependencies.push 'coffee-script' if @options.coffee
    @npmInstall dependencies, save: true

module.exports = MeshbluConnectorGenerator
