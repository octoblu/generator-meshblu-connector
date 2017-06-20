GitHubApi  = require 'github'
url        = require 'url'
_          = require 'lodash'

class Helpers
  extractMeshbluConnectorName: (appName) =>
    _.kebabCase appName

  githubUserInfo: (user, callback) =>
    github = new GitHubApi version: '3.0.0'

    unless _.isEmpty process.env.GITHUB_TOKEN
      github.authenticate
        type: 'oauth'
        token: process.env.GITHUB_TOKEN

    github.user.getFrom { user }, callback

  githubSlug: (githubUrl, appname) =>
    parsedGithub = url.parse githubUrl
    parts = parsedGithub.pathname.split '/'
    return "#{parts[1]}/#{appname}"

  mergeJSON: ({ input, overwriteWith }) =>
    returnObj = _.cloneDeep(input)
    _.each overwriteWith, (value, key) =>
      if _.isPlainObject(value)
        returnObj[key] = _.assign(returnObj[key], value)
      return value
    return returnObj

  validateName: (connectorName) =>
    return true if /^meshblu\-connector\-/.test connectorName
    return 'Name must be prefixed with "meshblu-connector-"'

module.exports = new Helpers
