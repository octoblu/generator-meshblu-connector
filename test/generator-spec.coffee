path    = require 'path'
helpers = require 'yeoman-test'
assert  = require 'yeoman-assert'
Mocha   = require 'mocha'
fs      = require 'fs'
npm     = require 'npm'

GENERATOR_NAME = 'yoyo'
DEST = path.join __dirname, '..', 'tmp', "meshblu-connector-#{GENERATOR_NAME}"

describe 'Generator', ->
  before 'run the helper', (done) ->
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
      .on 'end', done

  it 'creates expected files', ->
    assert.file '''
      test/meshblu-connector-spec.coffee
      test/test_helper.coffee
      test/mocha.opts
      schemas.json
      index.coffee
      index.js
      coffeelint.json
      .gitignore
      .travis.yml
      appveyor.yml
      LICENSE
      README.md
      package.json
    '''.split /\s+/g

  describe 'when the package.json is written', ->
    beforeEach ->
      @pkg = require path.join @tmpDir, 'package.json'

    it 'should have version 1.0.0', ->
      expect(@pkg.version).to.equal '1.0.0'

    it 'should have the correct githubSlug in the package.json', ->
      expect(@pkg.meshbluConnector.githubSlug).to.deep.equal 'sqrtofsaturn/meshblu-connector-yoyo'

  describe 'when the tests are ran', ->
    before (done) ->
      @timeout 20000
      npm.load production: false, progress: false, =>
        minimumModules = ['debug', 'coffee-script', 'chai', 'sinon', 'sinon-chai']
        npm.commands.install @tmpDir, minimumModules, done

    beforeEach ->
      testDir = path.join @tmpDir, 'test'
      @mocha = new Mocha()

      fs.readdirSync(testDir)
        .filter (file) =>
          return file.substr(-7) == '.coffee'
        .forEach (file) =>
          @mocha.addFile path.join testDir, file

    it 'should pass the tests', (done) ->
      @mocha.run (failures) =>
        expect(failures).to.be.empty
        done()
