<%= classPrefix %> = require '../'

describe '<%= classPrefix %>', ->
  beforeEach ->
    @sut = new <%= classPrefix %>

  it 'should have the start method', ->
    expect(@sut.start).to.be.a 'function'

  it 'should have the close method', ->
    expect(@sut.close).to.be.a 'function'

  it 'should call the callback when close is called', (done) ->
    @sut.close => done()

  it 'should have an onMessage method', ->
    expect(@sut.onMessage).to.be.a 'function'

  it 'should have on onConfig method', ->
    expect(@sut.onConfig).to.be.a 'function'
