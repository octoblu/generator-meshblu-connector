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
    @option 'channel'
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @skipInstall = options['skip-install']
    @githubUser  = options['github-user']

    if options['channel']
      console.error '[Deprecated] channel generation is no longer supported in this generator'
      process.exit 1

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
    @copy '_npmignore', '.npmignore'

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

    @_updatePkgJSON context
    @template "_command.js", "command.js", context
    @template "_index.js", "index.js", context
    @template "_coffeelint.json", "coffeelint.json", context
    @template "_appveyor.yml", "appveyor.yml", context
    @template "_travis.yml", ".travis.yml", context
    @template "_README.md", "README.md", context
    @template "_LICENSE", "LICENSE", context
    @template "test/_connector-spec.coffee", "test/connector-spec.coffee", context
    @template "test/_mocha.opts", "test/mocha.opts", context
    @template "test/_test_helper.coffee", "test/test_helper.coffee", context
    @template "test/jobs/_do-something-spec.coffee", "test/jobs/do-something-spec.coffee", context
    @template "src/_index.coffee", "src/index.coffee", context
    @copy "configs/default/config.cson", "configs/default/config.cson"
    @copy "configs/default/form.cson", "configs/default/form.cson"
    @copy "jobs/do-something/action.coffee", "jobs/do-something/action.coffee"
    @copy "jobs/do-something/form.cson", "jobs/do-something/form.cson"
    @copy "jobs/do-something/index.coffee", "jobs/do-something/index.coffee"
    @copy "jobs/do-something/job.coffee", "jobs/do-something/job.coffee"
    @copy "jobs/do-something/message.cson", "jobs/do-something/message.cson"
    @copy "jobs/do-something/response.cson", "jobs/do-something/response.cson"

  _updatePkgJSON: (context) =>
    unless @pkg?
      @template '_package.json', 'package.json', context
      return
    { githubSlug } = context
    templatePkg = @_readTemplateAsJSON '_update_package.json'
    newPackage = helpers.mergeJSON({ input: @pkg, overwriteWith: templatePkg })
    newPackage.name = @fullAppName
    newPackage.meshbluConnector ?= {}
    newPackage.meshbluConnector.githubSlug ?= githubSlug
    return @_writeFileAsJSON(newPackage, 'package.json')

  _readFile: (relativePath) =>
    fullPath = path.join @cwd, relativePath
    try
      return require fullPath
    catch
      return null

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
