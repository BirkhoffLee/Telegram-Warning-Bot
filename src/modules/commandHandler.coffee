module.exports = (command, message) ->
    switch command
        when "start", "help"
            global.Bot.telegram.sendMessage message,
                "This bot is for people to immediately know the terrible weathers which are going to happen."
        else
            return