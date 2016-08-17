local status = require("gateway.module.status")
local summary = require("gateway.module.summary")

local API = {}


API["/status"] = {
    GET = function()
        return function(req, res, next)
            local resport = status.report()
            if resport then
                res:json(resport, true)
            else
                res:status(500)
            end
        end
    end
}

API["/summary"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.report()
            if resport then
                res:json(resport, true)
            else
                res:status(500)
            end
        end
    end
}

API["/summary_history"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.history_report()
            if resport then
                res:json(resport, true)
            else
                res:status(500)
            end
        end
    end
}

API["/summary_one_minute"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.last_one_minute_report()
            if resport then
                res:json(resport, true)
            else
                res:status(500)
            end
        end
    end
}


return API
