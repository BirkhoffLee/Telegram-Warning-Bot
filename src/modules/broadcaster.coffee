Q = require "q"

list = [130878653]

module.exports = (result) ->
    deferred = Q.defer()

    global.Bot.telegram.sendMessage chatID, result for chatID in list