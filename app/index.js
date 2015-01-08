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

    var prompts = [{
      name: 'connectorName',
      message: 'What is the name of your connector?'
    }];

    this.prompt(prompts, function (props) {
      this.connectorName = props.connectorName;

      done();
    }.bind(this));
  },

  configuring: {
    enforceFolderName: function () {
      this.destinationRoot(this.connectorName);
      this.config.save();
    }
  },

  writing: {
    app: function () {
      this.src.template('_package.json', 'package.json');
      this.src.template('_index.js', 'index.js');
      this.src.copy('_command.js', 'command.js');
      this.src.copy('_gitignore', '.gitignore');
      this.src.copy('_meshblu.json', 'meshblu.json');
      this.src.copy('_connector.js', 'connector.js');
    }
  },

  end: function () {
    this.installDependencies({bower: false});
  }
});

module.exports = MeshbluConnectorGenerator;
