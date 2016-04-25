path    = require 'path'
helpers = require 'yeoman-test'
assert  = require 'yeoman-assert'

GENERATOR_NAME = 'yoyo'
DEST = path.join __dirname, '..', 'tmp', "meshblu-connector-#{GENERATOR_NAME}"

describe 'Generator', ->
  before 'run the helper', (done) ->
    helpers
      .run path.join __dirname, '..', 'app'
      .inDir DEST
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
