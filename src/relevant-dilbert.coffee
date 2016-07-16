# Description
#   A Hubot script to find the relevant Dilbert strip for a phrase
#
# Configuration:
#   none
#
# Commands:
#   hubot relevant dilber <search query> - returns an image link
#
# Notes:
#
# Author:
#   jonyeezs
request = require 'request'
cheerio = require 'cheerio'

URL = 'http://dilbert.com/search_results?terms='
IMAGE_CSS_SELECTOR = 'img.img-responsive'
NO_RESULT_CSS_SELECTOR = '.no-results'

NO_RESULT_MSG = 'sorry no image found'
FATAL_MSG = 'sorry cannot screen scrape'

module.exports = (robot) ->
  robot.respond /relevant dilbert (.+)/i, (res) ->
    query = res.match[1]
    errorMsg = FATAL_MSG
    image = ""
    request.get URL + query, (error, response, body) ->
      if !error && body && response.statusCode == 200
        image = getImage(body)
        errorMsg = getHandledError(body) if !image
      if image then res.send image else res.reply errorMsg

  getImage = (body) ->
    html = cheerio.load body
    html(IMAGE_CSS_SELECTOR).attr 'src'

  getHandledError = (body) ->
    html = cheerio.load body
    return if html(NO_RESULT_CSS_SELECTOR) then NO_RESULT_MSG else FATAL_MSG
