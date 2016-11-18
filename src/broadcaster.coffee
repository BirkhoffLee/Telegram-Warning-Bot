list = [130878653, "@taiwanDisasters"]

module.exports = (string) ->
    list.forEach (chatID) ->
	    global.Bot.telegram.sendWarning chatID, string