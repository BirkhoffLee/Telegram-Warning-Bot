username = null

bot = new new require('telegram-bot-api')
    token: global.Bot.config.telegram.token
    updates:
        enabled: true

bot.getMe()
    .then (data) ->
        username = data.username
        console.log "Successfully conencted to Telegram API Server.\n"
    .catch (err) ->
        if err.name == "RequestError"
            console.error "Unable to connect to Telegram API Server."
        else
            console.error "Unable to get the bot's username."

        process.exit -1

sendMessageErrorHandler = (err) ->
    console.error err

sendMessage = (message, text) ->
    if "object" == typeof message
        bot.sendMessage
            chat_id: message.chat.id
            reply_to_message_id: message.message_id
            disable_web_page_preview: "true"
            parse_mode: "html"
            text: text
        .catch sendMessageErrorHandler
    else
        # The "message" here is a chat id
        bot.sendMessage
            chat_id: message
            disable_web_page_preview: "true"
            parse_mode: "html"
            text: text
        .catch sendMessageErrorHandler

sendWarning = (to, message) ->
    bot.sendMessage
        chat_id: to
        parse_mode: "html"
        text: text
    .catch sendMessageErrorHandler

bot.on 'message', (message) ->
    if !message.text?
        return

    console.log "@#{message.from.username} (#{message.from.id} @ #{message.chat.id}): #{message.text}"

    firstPiece = message.text.split(" ")[0]
    command = firstPiece.replace(new RegExp("@#{username}", "i"), "").slice(1).trim()

    global.Bot.commandHandler command, message

module.exports =
    bot: bot
    sendMessage: sendMessage
    sendWarning: sendWarning
    username: username