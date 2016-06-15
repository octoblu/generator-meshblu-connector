Job = require './job.coffee'

module.exports = (options, message, callback) =>
  job = new Job options
  job.do message, callback
