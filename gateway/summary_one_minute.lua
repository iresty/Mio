local summary = require "gateway.module.summary"

ngx.say(summary.last_one_minute_report())
