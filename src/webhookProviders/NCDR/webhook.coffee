parseXML = require('xml2js').parseString
toXML    = require "js2xmlparser"

global.Bot.app.post '/webhook/ncdr', (req, res) ->
    res.set 'Content-Type', 'text/xml'

    console.log req.body

    xml = req.body

    parseXML xml, (err, result) ->
        if err
            res.end toXML "Data", {"Status": "true"}
            console.error err
            return false

        if typeof result.alert.info != undefined
            console.log result.alert.info

    res.end toXML "Data", {"Status": "true"}
