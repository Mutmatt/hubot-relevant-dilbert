Helper = require('hubot-test-helper')
chai = require 'chai'
sinon = require 'sinon'
request = require 'request'

expect = chai.expect

helper = new Helper('../src/relevant-dilbert.coffee')

describe 'hubot-relevant-dilbert', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach (done) ->
    @room.destroy()
    request.get.restore()
    done()

  context 'search has results', ->
    before (done) ->
      sinon.stub(request, 'get')
        .yields(null, {statusCode: 200}, HtmlWithImages);
      done()

    it 'sends an image', ->
      @room.user.say('alice', '@hubot relevant dilbert robot power').then =>
        expect(@room.messages).to.eql [
          ['alice', '@hubot relevant dilbert robot power']
          ['hubot', 'http://myfirstdilbertimage']
        ]

  context 'search has no results', ->
    before (done) ->
      sinon.stub(request, 'get')
        .yields(null, {statusCode: 200}, HtmlNoResults);
      done()

    it 'replies to the user', ->
      @room.user.say('bob', '@hubot relevant dilbert no image').then =>
        expect(@room.messages).to.eql [
          ['bob', '@hubot relevant dilbert no image']
          ['hubot', '@bob sorry no image found']
        ]

  context 'errors', ->
    status = statusCode: 404
    beforeEach (done) ->
      sinon.stub(request, 'get')
      .yields(null, status , null);
      done()

    it 'response to 404', ->
      @room.user.say('bob', '@hubot relevant dilbert an image').then =>
        expect(@room.messages).to.eql [
          ['bob', '@hubot relevant dilbert an image']
          ['hubot', '@bob sorry cannot screen scrape']
        ]

    it 'response to null', ->
      status.statusCode = 200
      @room.user.say('bob', '@hubot relevant dilbert an image').then =>
        expect(@room.messages).to.eql [
          ['bob', '@hubot relevant dilbert an image']
          ['hubot', '@bob sorry cannot screen scrape']
        ]

HtmlWithImages =
  '<html><div>Some stuff i do not care</div><div class="img-comic-container"><a itemprop="image" class="img-comic-link" href="http://dilbert.com/strip/2005-11-16" title="Click to see the comic strip "><img class="img-responsive img-comic" width="900" height="283" alt=" - Dilbert by Scott Adams" src="http://myfirstdilbertimage" /></a></div><div class="img-comic-container"><a itemprop="image" class="img-comic-link" href="http://dilbert.com/strip/2005-11-16" title="Click to see the comic strip "><img class="img-responsive img-comic" width="900" height="283" alt=" - Dilbert by Scott Adams" src="http://myseconddilbertimage" /></a></div></html>'

HtmlNoResults =
  '<div class="col-sm-8"><div class="no-results"><h2>No results found here dawg.</h2><p>WhatWHat</p></div></div>'
