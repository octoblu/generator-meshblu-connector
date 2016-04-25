util       = require 'util'
path       = require 'path'
url        = require 'url'
htmlWiring = require 'html-wiring'
yeoman     = require 'yeoman-generator'
_          = require 'lodash'
helpers    = require './helpers'

class MeshbluConnectorGenerator extends yeoman.Base
  constructor: (args, options, config) ->
    super
    @option 'github-user'
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @skipInstall = options['skip-install']
    @githubUser  = options['github-user']
    @pkg = JSON.parse htmlWiring.readFileAsString path.join __dirname, '../package.json'

  initializing: =>
    @appname = _.kebabCase @appname

  prompting: =>
    done = @async()

    prompts = [
      {
        name: 'githubUser'
        message: 'Would you mind telling me your username on GitHub?'
        default: 'octoblu'
      },
      {
        name: 'connectorName'
        message: 'What is the name of the connector?'
        default: @appname
      }
    ]

    @prompt prompts, ({@githubUser, @connectorName}) =>
      @noMeshbluConnector = _.replace @connectorName, /^meshblu-connector-/, ''
      done()

  userInfo: =>
    return if @realname? and @githubUrl?

    done = @async()

    helpers.githubUserInfo @githubUser, (error, res) =>
      @env.error error if error?
      @realname = res.name
      @email = res.email
      @githubUrl = res.html_url
      done()

  configuring: =>
    @copy '_gitignore', '.gitignore'

  writing: =>
    filePrefix     = _.kebabCase @noMeshbluConnector
    instancePrefix = _.camelCase @noMeshbluConnector
    classPrefix    = _.upperFirst instancePrefix
    constantPrefix = _.toUpper _.snakeCase @noMeshbluConnector
    appname        = "meshblu-connector-#{@noMeshbluConnector}"
    githubSlug     = helpers.githubSlug @githubUrl, appname

    context = {
      @githubUrl
      @realname
      appname,
      githubSlug,
      filePrefix
      classPrefix
      instancePrefix
      constantPrefix
    }

    @template "_package.json", "package.json", context
    @template "test/_meshblu-connector-spec.coffee", "test/meshblu-connector-spec.coffee", context
    @template "test/_mocha.opts", "test/mocha.opts", context
    @template "test/_test_helper.coffee", "test/test_helper.coffee", context
    @template "_index.coffee", "index.coffee", context
    @template "_index.js", "index.js", context
    @template "_coffeelint.json", "coffeelint.json", context
    @template "_appveyor.yml", "appveyor.yml", context
    @template "_travis.yml", ".travis.yml", context
    @template "_README.md", "README.md", context
    @template "_LICENSE", "LICENSE", context


  install: =>
    return if @skipInstall

    @installDependencies npm: true, bower: false

  end: =>
    return if @skipInstall

module.exports = MeshbluConnectorGenerator
