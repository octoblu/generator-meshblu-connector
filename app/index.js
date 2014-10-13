'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var yosay = require('yosay');

var MeshbluConnectorGenerator = yeoman.generators.Base.extend({
  initializing: function () {
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the Meshblu Connector generator!'
    ));
    done();
  },

  writing: {
    app: function () {
      this.src.copy('_package.json', 'package.json');
      this.src.copy('_command.js', 'command.js');
      this.src.copy('_gitignore', '.gitignore');
      this.src.copy('_meshblu.json', 'meshblu.json');
      this.src.copy('_index.js', 'index.js');
    }
  },

  end: function () {
    this.installDependencies();
  }
});

module.exports = MeshbluConnectorGenerator;
