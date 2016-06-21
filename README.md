# generator-meshblu-connector

[![Dependency status](http://img.shields.io/david/octoblu/generator-meshblu-connector.svg?style=flat)](https://david-dm.org/octoblu/generator-meshblu-connector)
[![devDependency Status](http://img.shields.io/david/dev/octoblu/generator-meshblu-connector.svg?style=flat)](https://david-dm.org/octoblu/generator-meshblu-connector#info=devDependencies)
[![Build Status](http://img.shields.io/travis/octoblu/generator-meshblu-connector.svg?style=flat&branch=master)](https://travis-ci.org/octoblu/generator-meshblu-connector)
[![Slack Status](http://community-slack.octoblu.com/badge.svg)](http://community-slack.octoblu.com)

[![NPM](https://nodei.co/npm/generator-meshblu-connector.svg?style=flat)](https://npmjs.org/package/generator-meshblu-connector)

> [Yeoman](http://yeoman.io) generator

A component of [Meshblu Connectors](https://meshblu-connectors.readme.io). Click [here](https://meshblu-connectors.readme.io/docs/connector-generator) to view the component documentation.

## Getting Started

### Install Yeoman

```bash
npm install -g yo
```

### Install the Generator

```bash
npm install -g generator-meshblu-connector
```

Finally, initiate the generator. However there is more automated [script](#update-meshblu-connector) for updating connectors.

```bash
yo meshblu-connector
```

### Automated Scripts

#### update-meshblu-connector

This script automates travis-ci, appveyor, running the generator, and updating the dependencies.

**Usage:**

```bash
cd /path/to/connector
env GITHUB_RELEASE_KEY='--insert-key-here--' APPVEYOR_GITHUB_RELEASE_KEY='--insert-key-here--' update-meshblu-connector
```

#### test-meshblu-connector

This script makes it easy to test a connector in production. It creates a Meshblu device, writes it to the meshblu.json, claims the device, updates the schema, and opens it in octoblu.

**Usage:**

```bash
cd /path/to/connector
test-meshblu-connector "--insert-octoblu-user-uuid---"
```

## License

MIT
