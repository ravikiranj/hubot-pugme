# Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pug me - Receive a pug
#   hubot pug bomb N - get N pugs

module.exports = (robot) ->
  MIN_PUGS = 1
  MAX_PUGS = 10

  robot.respond /pug me/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).pug

  robot.respond /pug bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    clampedPugs = clampPugsCount count, MIN_PUGS, MAX_PUGS
    if count > MAX_PUGS
      msg.send "Buzzkill Mode™ has enforced maximum pugs to #{clampedPugs}"
    msg.http("http://pugme.herokuapp.com/bomb?count=" + clampedPugs)
      .get() (err, res, body) ->
        msg.send pug for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."

  clampPugsCount = (count, min, max) ->
    return Math.min(Math.max(count, min), max)

