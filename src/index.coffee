EventEmitter = require('events').EventEmitter; 

# Initalize global vars
global.Bot = {}
global.Bot.event = new EventEmitter()

# System-wide modules
global.Bot.config = require './config.json'
global.Bot.broadcaster = require './broadcaster.coffee'
global.Bot.launchChecks = require './checks.coffee'

# Initalize NCDR module
global.Bot.NCDR = require './ncdr.coffee'

# HOOK: Launch check loops
#       when successfully connected
#       to Telegram server
global.Bot.event.on 'telegram_connected', ->
	global.Bot.launchChecks()

# Initalize Telegram module and start connecting
global.Bot.telegram = require './telegram.coffee'