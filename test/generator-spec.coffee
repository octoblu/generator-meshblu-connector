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
      test/meshblu-connector-spec.coffee
      test/test_helper.coffee
      test/mocha.opts
      src/index.coffee
      schemas.json
      command.js
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

    it 'should have the correctly formatted name', ->
      expect(/^meshblu-connector/.test(@pkg.name)).to.be.true

    it 'should have meshblu-connector-runner in the dependencies', ->
      expect(@pkg.dependencies['meshblu-connector-runner']).to.not.be.empty

    it 'should have meshblu-connector-packager in the devDependencies', ->
      expect(@pkg.devDependencies['meshblu-connector-packager']).to.not.be.empty

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
