toXML     = require "js2xmlparser"
process   = require "./process.coffee"
broadcast = require "../../modules/broadcaster.coffee"

global.Bot.app.post '/webhook/ncdr', (req, res) ->
    res.set 'Content-Type', 'text/xml'

    xml = req.body

    process xml
        .then broadcast

    res.end toXML "Data", {"Status": "true"}
