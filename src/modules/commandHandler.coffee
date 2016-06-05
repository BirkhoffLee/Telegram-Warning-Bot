module.exports = (command) ->
    switch command
        when "start", "help"
            global.Bot.telegram.sendMessage message,
                "This bot is for people to immediately know the terrible weathers are going to happen."
        else
            return