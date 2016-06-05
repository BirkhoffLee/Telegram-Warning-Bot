Promise = require 'bluebird'

global.config =
    telegram:
        token: ""
    httpServer:
        port: process.env.PORT
        ip: process.env.IP

global.Bot =
    webhookHandler:  require './modules/webhookHandler.coffee'
    commandHandler:  require './modules/commandHandler.coffee'
    telegram:        require './modules/telegram.coffee'