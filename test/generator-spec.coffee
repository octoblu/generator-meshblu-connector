_       = require 'lodash'
path    = require 'path'
helpers = require 'yeoman-test'
assert  = require 'yeoman-assert'
Mocha   = require 'mocha'
glob    = require 'glob'
npm     = require 'npm'

GENERATOR_NAME = 'yoyo'
DEST = path.join __dirname, '..', 'tmp', "meshblu-connector-#{GENERATOR_NAME}"

describe 'Generator', ->
  before 'run the helper', (done) ->
    @timeout 10000
    appDir = path.join __dirname, '..', 'app'
    helpers
      .run appDir
      .inTmpDir (dir) =>
        @tmpDir = dir
      .withOptions
        realname: 'Sqrt of Saturn'
        githubUrl: 'https://github.com/sqrtofsaturn'
      .withPrompts
        githubUser: 'sqrtofsaturn'
        connectorName: GENERATOR_NAME
      .on 'error', (error) =>
        done error
      .on 'end', done

  it 'creates expected files', ->
    assert.file '''
      configs/default.cson
      jobs/do-something/action.coffee
      jobs/do-something/form.cson
      jobs/do-something/index.coffee
      jobs/do-something/job.coffee
      jobs/do-something/message.cson
      jobs/do-something/response.cson
      test/connector-spec.coffee
      test/test_helper.coffee
      test/mocha.opts
      src/index.coffee
      command.js
      index.js
      coffeelint.json
      .gitignore
      .npmignore
      .travis.yml
      appveyor.yml
      LICENSE
      README.md
      package.json
    '''.split /\s+/g

  describe 'when the package.json is written', ->
    beforeEach ->
      @pkg = require path.join @tmpDir, 'package.json'

    it 'should have the correctly formatted name', ->
      expect(/^meshblu-connector/.test(@pkg.name)).to.be.true

    it 'should have meshblu-connector-runner in the dependencies', ->
      expect(@pkg.dependencies['meshblu-connector-runner']).to.not.be.empty

    it 'should have main pointing to index.js', ->
      expect(@pkg.main).to.equal 'index.js'

    it 'should have version 1.0.0', ->
      expect(@pkg.version).to.equal '1.0.0'

    it 'should have the correct githubSlug in the package.json', ->
      expect(@pkg.meshbluConnector.githubSlug).to.deep.equal 'sqrtofsaturn/meshblu-connector-yoyo'

  describe 'when the tests are ran', ->
    before (done) ->
      @timeout 20000
      npm.load production: false, progress: false, =>
        minimumModules = ['debug', 'coffee-script', 'chai', 'sinon', 'sinon-chai', 'fs-cson']
        npm.commands.install @tmpDir, minimumModules, done

    beforeEach (done) ->
      testFiles = path.join @tmpDir, 'test', "**/*-spec.*"
      @mocha = new Mocha()

      glob testFiles, (error, files) =>
        return done error if error?
        _.each files, (file) =>
          @mocha.addFile file
        done()

    it 'should pass the tests', (done) ->
      @mocha.run (failures) =>
        expect(failures).to.be.empty
        done()
