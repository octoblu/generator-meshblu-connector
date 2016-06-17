chai      = require 'chai'
sinon     = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai

global.expect = chai.expect
global.sinon  = sinon

if process.env.DEBUG_CORE_DUMP == 'true'
  SegfaultHandler = require 'segfault-handler'
  SegfaultHandler.registerHandler 'crash.log'
