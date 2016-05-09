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
    @cwd = @destinationRoot()
    @pkg = @_readFileAsJSON 'package.json'

  initializing: =>
    @appname = _.kebabCase @appname

  prompting: =>
    done = @async()

    prompts = [
      {
        type: 'input'
        name: 'githubUser'
        message: 'Would you mind telling me your username on GitHub?'
        default: 'octoblu'
      },
      {
        type: 'input'
        name: 'connectorName'
        message: 'What is the name of the connector?'
        default: @appname
        validate: helpers.validateName
      }
    ]

    @prompt prompts, ({@githubUser, @connectorName}) =>
      @noMeshbluConnector = _.replace @connectorName, /^meshblu-connector-/, ''
      @fullAppName        = "meshblu-connector-#{@noMeshbluConnector}"
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
    appname        = @fullAppName
    githubSlug     = helpers.githubSlug @githubUrl, appname

    context = {
      @currentYear
      @githubUrl
      @realname
      appname,
      githubSlug,
      filePrefix
      classPrefix
      instancePrefix
      constantPrefix
    }

    @_updatePkgJSON({ githubSlug }) if @pkg?
    @template '_package.json', 'package.json', context unless @pkg?

    @template "test/_meshblu-connector-spec.coffee", "test/meshblu-connector-spec.coffee", context
    @template "test/_mocha.opts", "test/mocha.opts", context
    @template "test/_test_helper.coffee", "test/test_helper.coffee", context
    @template "src/_index.coffee", "src/index.coffee", context
    @template "_schemas.json", "schemas.json", context
    @template "_command.js", "command.js", context
    @template "_index.js", "index.js", context
    @template "_coffeelint.json", "coffeelint.json", context
    @template "_appveyor.yml", "appveyor.yml", context
    @template "_travis.yml", ".travis.yml", context
    @template "_README.md", "README.md", context
    @template "_LICENSE", "LICENSE", context

  _updatePkgJSON: ({ githubSlug }) =>
    templatePkg = @_readTemplateAsJSON '_update_package.json'
    newPackage = helpers.mergeJSON({ input: @pkg, overwriteWith: templatePkg })
    newPackage.name = @fullAppName
    newPackage.meshbluConnector ?= {}
    newPackage.meshbluConnector.githubSlug ?= githubSlug
    newPackage.meshbluConnector.schemasUrl ?= "https://raw.githubusercontent.com/#{githubSlug}/v#{@pkg.version}/schemas.json"
    return @_writeFileAsJSON(newPackage, 'package.json')

  _readTemplateAsJSON: (relativePath) =>
    fullPath = path.join __dirname, 'templates', relativePath
    try
      return JSON.parse htmlWiring.readFileAsString fullPath
    catch
      return null

  _readFileAsJSON: (relativePath) =>
    fullPath = path.join @cwd, relativePath
    try
      return JSON.parse htmlWiring.readFileAsString fullPath
    catch
      return null

  _writeFileAsJSON: (jsonObj, relativePath) =>
    fullPath = path.join @cwd, relativePath
    try
      return @write fullPath, JSON.stringify(jsonObj, null, 2)
    catch error
      console.error error

  install: =>
    return if @skipInstall

    @installDependencies npm: true, bower: false

  end: =>
    return if @skipInstall

module.exports = MeshbluConnectorGenerator
