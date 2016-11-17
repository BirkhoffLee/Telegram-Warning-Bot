module.exports = (command, message) ->
    switch command
        when "start", "help"
            global.Bot.telegram.sendMessage message,
                "This bot is for telling people about the terrible weathers like earthquake."
        else
            return