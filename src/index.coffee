Promise = require 'bluebird'

global.config =
    telegram:
        token: ""

global.Bot =
    webhookHandler:  require './modules/webhookHandler.coffee'
    commandHandler:  require './modules/commandHandler.coffee'
    telegram:        require './modules/telegram.coffee'