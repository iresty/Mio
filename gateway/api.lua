local status = require("gateway.module.status")
local summary = require("gateway.module.summary")


API["/status"] = {
    GET = function()
        return function(req, res, next)
            local resport = status.report()
            if resport then
                res:json({
                    success = true,
                    msg = "",
                    data = resport
                }, true)
            else
                res:json({
                    success = false,
                    msg = "error to get `status`"
                })
            end
        end
    end
}


API["/summary"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.report()
            if resport then
                res:json({
                    success = true,
                    msg = "", 
                    data = resport
                }, true)
            else
                res:json({
                    success = false,
                    msg = "error to get `status`"
                })
            end
        end
    end
}


API["/summary_history"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.history_report()
            if resport then
                res:json({
                    success = true,
                    msg = "", 
                    data = resport
                }, true)
            else
                res:json({
                    success = false,
                    msg = "error to get `status`"
                })
            end
        end
    end
}

API["/summary_one_minute"] = {
    GET = function()
        return function(req, res, next)
            local resport = summary.last_one_minute_report()
            if resport then
                res:json({
                    success = true,
                    msg = "", 
                    data = resport
                }, true)
            else
                res:json({
                    success = false,
                    msg = "error to get `status`"
                })
            end
        end
    end
}


return API
