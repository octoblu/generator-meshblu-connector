{job} = require '../../jobs/do-something'

describe 'DoSomething', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector = {}
      message =
        data:
          example: 'hi'
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
