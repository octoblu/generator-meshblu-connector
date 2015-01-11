'use strict';
var yeoman = require('yeoman-generator');
var yosay = require('yosay');

var MeshbluConnectorGenerator = yeoman.generators.Base.extend({
  constructor: function () {
    yeoman.generators.Base.apply(this, arguments);

    this.option('coffee');
  },

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
      if(this.options.coffee){
        this.template('_package.coffee.json', 'package.json');
        this.template('_index.coffee.js', 'index.js');
        this.template('_index.coffee', 'index.coffee');
        this.copy('_command.coffee.js', 'command.js');
        this.copy('_command.coffee', 'command.coffee');
        this.copy('_gitignore_coffee', '.gitignore');
        this.copy('_connector.coffee', 'connector.coffee');
      } else {
        this.template('_package.json', 'package.json');
        this.template('_index.js', 'index.js');
        this.copy('_command.js', 'command.js');
        this.copy('_gitignore', '.gitignore');
        this.copy('_connector.js', 'connector.js');
      }
      this.copy('_meshblu.json', 'meshblu.json');
    }
  },

  end: function () {
    this.installDependencies({bower: false});
  }
});

module.exports = MeshbluConnectorGenerator;
