global.Bot = {}

global.Bot.config =
    telegram:
        token: "190533682:AAENNr8amcOx2r9Mwy5YJY-VjLiNMx8DBqY"
    httpServer:
        port: process.env.PORT
        ip: process.env.IP

global.Bot.webhookHandler = require './modules/webhookHandler.coffee'
global.Bot.commandHandler = require './modules/commandHandler.coffee'
global.Bot.telegram       = require './modules/telegram.coffee'