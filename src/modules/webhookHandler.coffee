express     = require 'express'
bodyParser  = require 'body-parser'
weblogger   = require 'morgan'

global.Bot.app = express()

app         = global.Bot.app
ip          = global.Bot.config.httpServer.ip
port        = global.Bot.config.httpServer.port

# Make sure we will get the correct IP address
app.set 'trust proxy', 1

# Remove x-powered-by header
app.disable 'x-powered-by'

# Access logger
app.use weblogger ':remote-addr - ":user-agent" - ":method :url HTTP/:http-version" :status - :response-time ms'

# Initalize express-fileupload
app.use bodyParser.text
    type: "text/xml"

(require "require-directory") module, "../webhookProviders"

# Launch server
app.listen port, ip, ->
    console.log "Web server is listening on #{ip}:#{port}."

# The last route: 404 Not Found
app.use (req, res, next) ->
    res.status 404
    res.send "404 - Not Found. Requested URL: #{req.url}"