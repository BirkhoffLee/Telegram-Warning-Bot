Bot         = require 'telegram-bot-api'
exec        = require('child_process').exec
parseString = require('xml2js').parseString

######################

# The Telegram bot HTTP API token.
# @see https://core.telegram.org/bots#botfather
token    = "224919315:AAEMATO4dw1t8aQshlGqNWGHCTsKODEvfXw"

# The authentication key.
# @see http://opendata.cwb.gov.tw/usages
authkey  = "CWB-4E43E520-C734-4F8B-9E58-4CE59BAA6649"

# The data IDs.
# @see http://opendata.cwb.gov.tw/datalist
dataids  = ["E-A0015-001", "E-A0016-001"]

# The Telegram chat IDs we are sending earthquake notifies to.
sendIDs  = [130878653]

# Delay between every checks (in ms)
delay    = 15000

######################

apiurl                = "http://opendata.cwb.gov.tw/opendataapi?dataid={dataid}&authorizationkey=#{authkey}"
username              = ""
notifiedEarthquakeNos = []

bot = new Bot
    token: token
    updates:
        enabled: true

bot.getMe()
    .then (data) ->

        username = data.username
        console.log "Successfully conencted to Telegram API Server."

    .catch (err) ->
        if err.name == "RequestError"
            console.error "Unable to connect to Telegram API Server."
        else
            console.error "Unable to get the bot's username."

        process.exit -1

sendMessageErrorHandler = (err) ->
    console.error err

sendMessage = (message, text) ->
    bot.sendMessage
        chat_id: message.chat.id
        reply_to_message_id: message.message_id
        disable_web_page_preview: "true"
        parse_mode: "html"
        text: text
    .catch sendMessageErrorHandler

checkEarthquake = ->
    setTimeout ->
            try
                exec "rm -rf /tmp/*", (error, stdout, stderr) ->
                    if error
                        return 0
            catch error
                console.error error

            checkEarthquake()
    , delay + 12000

cleanCache = ->
    setTimeout ->
        dataids.forEach (dataid) ->
            try
                exec "tmpfile=`mktemp` && wget \"#{apiurl.replace "{dataid}", dataid}\" -O $tmpfile -q && unzip -qq -p $tmpfile", (error, stdout, stderr) ->
                    if error
                        return 0

                    parseString stdout, (err, result) ->
                        if error
                            console.error error
                            return 0

                        earthquake = result.cwbopendata.dataset[0].earthquake[0]

                        if -1 == notifiedEarthquakeNos.indexOf earthquake.earthquakeNo.toString()

                            notifiedEarthquakeNos.push earthquake.earthquakeNo.toString()

                            sendIDs.forEach (sendID) ->
                                bot.sendMessage
                                    chat_id: sendID
                                    text: "地震速報！#{earthquake.reportContent}\n詳細資料：#{earthquake.web}\n地震報告圖：#{earthquake.reportImageURI}"
                                .catch sendMessageErrorHandler
            catch error
                console.error error

            cleanCache()
    , delay

bot.on 'message', (message) ->
    console.log message
    if !message.text?
        return

    console.log "@#{message.from.username}: #{message.text}"

    firstPiece = message.text.split(" ")[0]
    quiet      = null

    switch firstPiece.replace(new RegExp("@#{username}", "i"), "").slice 1
        when "start", "help"

            bot.sendMessage
                chat_id: message.chat.id
                reply_to_message_id: message.message_id
                text: "This bot is for Taiwan people to know immediately when the bad weathers happen.\nWhen earthquake happens, we send the message to groups we have set manually."
            .catch sendMessageErrorHandler

        else
            return

checkEarthquake()
cleanCache()
