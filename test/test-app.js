/*global describe, beforeEach, it*/
'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');
var fs = require('fs');
var tmpPath = path.join(os.tmpdir(), './temp-test')

describe('meshblu-connector:app', function () {
  this.timeout(60000);

  before(function (done) {
    helpers.run(path.join(__dirname, '../app'))
      .inDir(tmpPath)
      .withOptions({ 'skip-install': true })
      .withPrompt({
        someOption: true
      })
      .on('end', done);
  });

  it('creates files', function () {
    var testDir = process.cwd()
    process.chdir(tmpPath)
    assert.equal(process.cwd(), testDir);
    assert.file([
      'package.json',
      'connector.js',
      'command.js',
      'README.md',
      'LICENSE'
    ]);
  });
});
