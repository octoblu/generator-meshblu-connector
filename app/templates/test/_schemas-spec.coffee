describe 'Schemas', ->
  it 'should be requirable', ->
    expect( => require('../schemas.json')).to.not.throw(Error)
