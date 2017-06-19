{afterEach, beforeEach, describe, it} = global
{expect} = require 'chai'
Connector = require '../'

describe 'Connector', ->
  beforeEach 'start the connector', (done) ->
    @sut = new Connector
    @sut.start {}, done

  afterEach 'shut it down', (done) ->
    @sut.close done

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)
