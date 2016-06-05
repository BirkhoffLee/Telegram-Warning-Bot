express     = require 'express'
bodyParser  = require 'body-parser'
weblogger   = require 'morgan'

app         = express()
ip          = global.config.httpServer.ip
port        = global.config.httpServer.port

# Make sure we will get the correct IP address
app.set 'trust proxy', 1

# Remove x-powered-by header
app.disable 'x-powered-by'

# Access logger
app.use weblogger ':remote-addr - ":user-agent" - ":method :url HTTP/:http-version" :status - :response-time ms'

# Initalize form data parser
app.use bodyParser.urlencoded
    limit: "50mb"
    extended: false
app.use bodyParser.json
    limit: "50mb"

# Launch server
app.listen global.config.httpServer.port, global.config.httpServer.ip, ->
    console.log "Web server launched and listening on #{ip}:#{port}."

# The last route: 404 Not Found
app.use (req, res, next) ->
    res.status 404
    res.send "404 - Not Found. Requested URL: #{req.url}"

module.exports = app