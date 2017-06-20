Generator  = require 'yeoman-generator'
_          = require 'lodash'
helpers    = require './helpers'

class MeshbluConnectorGenerator extends Generator
  constructor: (args, options) ->
    super
    @option 'github-user'
    @option 'channel'
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @skipInstall = options['skip-install']
    @githubUser  = options['github-user']

    @pkg = @fs.readJSON @destinationPath('package.json')

  initializing: =>
    @appname = _.kebabCase @appname

  prompting: =>
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

    return @prompt(prompts).then ({@githubUser, @connectorName}) =>
      @noMeshbluConnector = _.replace @connectorName, /^meshblu-connector-/, ''
      @fullAppName        = "meshblu-connector-#{@noMeshbluConnector}"

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
    @fs.copy @templatePath('_gitignore'), @destinationPath('.gitignore')
    @fs.copy @templatePath('_npmignore'), @destinationPath('.npmignore')

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
      appname
      githubSlug
      filePrefix
      classPrefix
      instancePrefix
      constantPrefix
    }

    @_updatePkgJSON context
    @fs.copyTpl @templatePath("_command.js"), @destinationPath("command.js"), context
    @fs.copyTpl @templatePath("_index.js"), @destinationPath("index.js"), context
    @fs.copyTpl @templatePath("_coffeelint.json"), @destinationPath("coffeelint.json"), context
    @fs.copyTpl @templatePath("_appveyor.yml"), @destinationPath("appveyor.yml"), context
    @fs.copyTpl @templatePath("_travis.yml"), @destinationPath(".travis.yml"), context
    @fs.copyTpl @templatePath("_wercker.yml"), @destinationPath("wercker.yml"), context
    @fs.copyTpl @templatePath("_README.md"), @destinationPath("README.md"), context
    @fs.copyTpl @templatePath("_LICENSE"), @destinationPath("LICENSE"), context
    @fs.copyTpl @templatePath("test/_connector-spec.coffee"), @destinationPath("test/connector-spec.coffee"), context
    @fs.copyTpl @templatePath("test/_mocha.opts"), @destinationPath("test/mocha.opts"), context
    @fs.copyTpl @templatePath("test/_test_helper.coffee"), @destinationPath("test/test_helper.coffee"), context
    @fs.copyTpl @templatePath("test/jobs/_do-something-spec.coffee"), @destinationPath("test/jobs/do-something-spec.coffee"), context
    @fs.copyTpl @templatePath("src/_index.coffee"), @destinationPath("src/index.coffee"), context
    @fs.copy @templatePath("configs/default/config.cson"), @destinationPath("configs/default/config.cson")
    @fs.copy @templatePath("configs/default/form.cson"), @destinationPath("configs/default/form.cson")
    @fs.copy @templatePath("configs/default/index.coffee"), @destinationPath("configs/default/index.coffee")
    @fs.copy @templatePath("jobs/do-something/action.coffee"), @destinationPath("jobs/do-something/action.coffee")
    @fs.copy @templatePath("jobs/do-something/form.cson"), @destinationPath("jobs/do-something/form.cson")
    @fs.copy @templatePath("jobs/do-something/index.coffee"), @destinationPath("jobs/do-something/index.coffee")
    @fs.copy @templatePath("jobs/do-something/job.coffee"), @destinationPath("jobs/do-something/job.coffee")
    @fs.copy @templatePath("jobs/do-something/message.cson"), @destinationPath("jobs/do-something/message.cson")
    @fs.copy @templatePath("jobs/do-something/response.cson"), @destinationPath("jobs/do-something/response.cson")

  _updatePkgJSON: (context) =>
    unless @pkg?
      return @fs.copyTpl @templatePath('_package.json'), @destinationPath('package.json'), context

    { githubSlug } = context
    templatePkg = @fs.readJSON @templatePath('_update_package.json')
    newPackage = helpers.mergeJSON({ input: @pkg, overwriteWith: templatePkg })
    newPackage.name = @fullAppName
    newPackage.meshbluConnector ?= {}
    newPackage.meshbluConnector.githubSlug ?= githubSlug
    return @fs.writeJSON @destinationPath('package.json'), newPackage

  install: =>
    return if @skipInstall

    @installDependencies npm: true, bower: false

  end: =>
    return if @skipInstall

module.exports = MeshbluConnectorGenerator
