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

    github.user.getFrom {user}, callback

  githubSlug: (githubUrl, appname) =>
    parsedGithub = url.parse githubUrl
    parts = parsedGithub.pathname.split '/'
    return "#{parts[1]}/#{appname}"

module.exports = new Helpers
