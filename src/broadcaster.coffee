list = [130878653, "@taiwanDisasters"]

module.exports = (string) ->
    global.Bot.telegram.sendWarning chatID, string for chatID in list
