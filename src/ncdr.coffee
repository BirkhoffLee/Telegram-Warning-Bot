request = require 'request'
broadcast = global.Bot.broadcaster

# Acquire configurations
url = global.Bot.config.NCDR.checkURL
categoriesToBroadcast = global.Bot.config.NCDR.categoriesToBroadcast
checkDataFrequency = global.Bot.config.NCDR.checkDataFrequencyInMs

# Initalize vars
lastUpdated = ""
broadcastedDataIDs = []
checkedTimes = 0

# Data-check loop
getData = ->
	checkedTimes++
	console.log "\nCheck ##{checkedTimes}"
	setTimer()

	request url, (err, res, body) ->
		if err || res.statusCode != 200
			return false

		result = JSON.parse body

		# To avoid repeated broadcasts
		if lastUpdated == result.updated
			return true

		lastUpdated = result.updated
		result.entry.forEach (data) ->

			# Only broadcast what we want to
			if data.category["@term"].indexOf(categoriesToBroadcast) == -1
				return true

			# To avoid repeated broadcasts
			if broadcastedDataIDs.indexOf(data.id) != -1
				return true

			# Mark this dataset to "broadcasted"
			broadcastedDataIDs.push data.id

			# Throw the checked data to the handler
			dataHandler data

# Formatter
dataHandler = (data) ->
	combinedString = "[#{data.title}] #{data.summary['#text'].trim()}"

	console.log combinedString
	broadcast combinedString

setTimer = ->
	setTimeout getData, checkDataFrequency

module.exports = {
	loop: getData
}
