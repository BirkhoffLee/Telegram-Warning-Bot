parseXML    = require('xml2js').parseString
fs          = require 'fs'

identifiers =
    earthquakeReport : "\u5730\u9707\u5831\u544a\u5716"
    officialAdvice   : "\u5b98\u65b9\u5efa\u8b70\uff1a"
    earthquake       : "\u5730\u9707"
    openParen        : "\uff08"
    closeParen       : "\uff09"
    flood            : "\u6df9\u6c34"
    colon            : "\uff1a"
    comma            : "\uff0c"
    one              : "\u4e00"
    two              : "\u4e8c"
    three            : "\u4e09"
    four             : "\u56db"
    five             : "\u4e94"
    six              : "\u516d"
    seven            : "\u4e03"
    eight            : "\u516b"
    nine             : "\u4e5d"
    mm               : "\u6beb\u7c73"

replacements = [
    { '\\:'             : identifiers.colon        }
    { '\\('             : identifiers.openParen    }
    { '\\)'             : identifiers.closeParen   }
    { '\\ ,'            : identifiers.comma        }
    { '\\,'             : identifiers.comma        }
    { 'mm'              : identifiers.mm           }
    { '([\\x00-\\xFF]+)(?=[^\\x00-\\xff])': " $1 " }
    { "  "              : " "                      }
    { "\n "             : "\n"                     }
    { " 1 "             : "#{identifiers.one   }"  }
    { " 2 "             : "#{identifiers.two   }"  }
    { " 3 "             : "#{identifiers.three }"  }
    { " 4 "             : "#{identifiers.four  }"  }
    { " 5 "             : "#{identifiers.five  }"  }
    { " 6 "             : "#{identifiers.six   }"  }
    { " 7 "             : "#{identifiers.seven }"  }
    { " 8 "             : "#{identifiers.eight }"  }
    { " 9 "             : "#{identifiers.nine  }"  }
]

fs.readFile '1.cap', (_e, _r) ->
    parseXML _r, (e, cap) ->
        if cap.alert.status.toString() == 'Test'
            # return 1
            '';

        alertInfo = cap.alert.info[0]
        event = alertInfo.event.toString()

        switch event
            when identifiers.earthquake
                description = alertInfo.description.toString()
                replace     = Object.keys(replacements[6]).toString()
                description = description.replace new RegExp(replace, "g"), replacements[6][replace]
                imageURL    = null

                alertInfo.resource.forEach (resourceObj) ->
                    if resourceObj.resourceDesc.toString() == identifiers.earthquakeReport
                        imageURL = resourceObj.uri.toString()

                result = "#{description}\n#{imageURL}"

                replacements.every (r, i) ->
                    replace = Object.keys(r).toString()

                    if replace == '\\:'
                        return

                    result  = result.replace new RegExp(replace, "g"), replacements[i][replace]

                console.log result.trim()
            when identifiers.flood
                eventDateObject = new Date alertInfo.effective.toString()
                description     = alertInfo.description.toString()
                instruction     = alertInfo.instruction.toString()
                eventDate       = "民國 #{eventDateObject.getFullYear() - 1911} 年 #{eventDateObject.getMonth()} 月 #{eventDateObject.getDate()} 日"

                result = "#{eventDate}#{description}\n#{identifiers.officialAdvice}#{instruction}"

                replacements.every (r, i) ->
                    replace = Object.keys(r).toString()
                    result  = result.replace new RegExp(replace, "g"), replacements[i][replace]

                console.log result.trim()