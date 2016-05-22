Bot         = require 'telegram-bot-api'
parseString = require('xml2js').parseString
fs          = require 'fs'
http        = require 'http'
Promise     = require 'bluebird'
url         = require 'url'
decompress  = require 'decompress'

######################

# The Telegram bot HTTP API token.
# @see https://core.telegram.org/bots#botfather
token    = ""

# The authentication key.
# @see http://opendata.cwb.gov.tw/usages
authkey  = ""

# The data IDs.
# @see http://opendata.cwb.gov.tw/datalist
dataids  = ["E-A0015-001", "E-A0016-001"]

# The Telegram chat IDs we are sending earthquake notifies to.
# sendIDs  = [130878653, 1001033293696]
sendIDs  = [130878653]

# Delay between every checks (in ms)
delay    = 15000

######################

apiurl   = "http://opendata.cwb.gov.tw/opendataapi?dataid={dataid}&authorizationkey=#{authkey}"
username = ""

bot = new Bot
    token: token
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
    bot.sendMessage
        chat_id: message.chat.id
        reply_to_message_id: message.message_id
        disable_web_page_preview: "true"
        parse_mode: "html"
        text: text
    .catch sendMessageErrorHandler

download = (remote, dest) ->
    remote = url.parse remote
    file   = fs.createWriteStream dest

    return new Promise (resolve, reject) ->
        req = http.request(remote, (res) ->
            if res.statusCode == 301 && res.headers.location
                resolve download res.headers.location
            else
                res.pipe file
                file.on 'finish', ->
                    file.close resolve
                .on 'error', (e) ->
                    reject e
        ).on 'error', (e) ->
            reject e
        .end()

checkEarthquake = ->
    setTimeout ->
        nowTime = Math.round(new Date().getTime() / 1000)

        dataids.forEach (dataid) ->
            zipPath = "/tmp/#{dataid}_#{nowTime}.zip"

            download apiurl.replace("{dataid}", dataid), zipPath
                .then ->
                    try
                        return decompress zipPath, "dist"
                    catch e
                        # ignore
                .then (files) ->
                    files.forEach (file) ->
                        parseString file.data.toString(), (err, result) ->
                            if err
                                console.error err
                                return 0

                            earthquake = result.cwbopendata.dataset[0].earthquake[0]
                            happenTime = Math.round(new Date(earthquake.earthquakeInfo[0].originTime).getTime() / 1000)

                            # We are only broadcasting earthquakes those happened within 60s
                            if nowTime - happenTime >= 60
                                return 0

                            message = "地震速報！#{earthquake.reportContent}\n詳細資料：#{earthquake.web}\n地震報告圖：#{earthquake.reportImageURI}"

                            console.log "#{message}\n"

                            sendIDs.forEach (sendID) ->
                                bot.sendMessage
                                    chat_id: sendID
                                    text: message
                                .catch sendMessageErrorHandler

                    if fs.existsSync zipPath
                        fs.unlink zipPath

                .catch (error) ->
                    return 0

            checkEarthquake()
    , delay

bot.on 'message', (message) ->
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
